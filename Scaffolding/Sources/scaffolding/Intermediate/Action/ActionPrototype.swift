import SDGLogic
import SDGCollections
import SDGText

struct ActionPrototype {
  var isFlow: Bool
  var names: Set<StrictString>
  var namespace: [Set<StrictString>]
  var parameters: Interpolation<ParameterIntermediate>
  var returnValue: ParsedTypeReference?
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var documentation: DocumentationIntermediate?
  var swiftName: StrictString?

  init(
    isFlow: Bool,
    names: Set<StrictString>,
    namespace: [Set<StrictString>],
    parameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference?,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    documentation: DocumentationIntermediate?,
    swiftName: StrictString?
  ) {
    self.isFlow = isFlow
    self.names = names
    self.namespace = namespace
    self.parameters = parameters
    self.returnValue = returnValue
    self.access = access
    self.testOnlyAccess = testOnlyAccess
    self.documentation = documentation
    self.swiftName = swiftName
  }
}

extension ActionPrototype {

  static func construct<S>(
    _ declaration: S,
    namespace: [Set<StrictString>]
  ) -> Result<ActionPrototype, ErrorList<ActionPrototype.ConstructionError>>
  where S: ParsedActionPrototype {
    var errors: [ActionPrototype.ConstructionError] = []
    let namesDictionary = declaration.name.names
    let parameters: Interpolation<ParameterIntermediate>
    switch Interpolation.construct(
      entries: namesDictionary.values,
      getEntryName: { $0.name() },
      getParameters: { $0.parameters() },
      getParameterName: { $0.name.name() },
      getDefinitionOrReference: { $0.definitionOrReference },
      getNestedSignature: { $0.name },
      getNestedParameters: { $0.parameters() },
      constructParameter: { ParameterIntermediate(names: $0, nestedParameters: $1!, returnValue: $2.type, isThrough: $2.isThrough) }
    ) {
    case .failure(let interpolationError):
      errors.append(contentsOf: interpolationError.errors.map({ .brokenParameterInterpolation($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      parameters = constructed
    }
    var names: Set<StrictString> = []
    var swiftName: StrictString?
    for (language, signature) in namesDictionary {
      let name = signature.name()
      if language == "Swift" {
        swiftName = name
      }
      names.insert(signature.name())
    }
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      let intermediateDocumentation = DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: namespace
          .appending(names)
      )
      attachedDocumentation = intermediateDocumentation
      let existingParameters = parameters.inAnyOrder.reduce(Set(), { $0 ∪ $1.names })
      for parameter in intermediateDocumentation.parameters.joined() {
        if parameter.name.identifierText() ∉ existingParameters {
          errors.append(ConstructionError.documentedParameterNotFound(parameter))
        }
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionPrototype(
        isFlow: declaration.isFlow,
        names: names,
        namespace: namespace,
        parameters: parameters,
        returnValue: declaration.returnValueType.map({ ParsedTypeReference($0) }),
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation,
        swiftName: swiftName
      )
    )
  }

  func validateReferences(referenceDictionary: ReferenceDictionary, errors: inout [ReferenceError]) {
    for parameter in parameters.inAnyOrder {
      parameter.type.validateReferences(
        requiredAccess: access,
        allowTestOnlyAccess: testOnlyAccess,
        referenceDictionary: referenceDictionary,
        errors: &errors
      )
    }
    returnValue?.validateReferences(
      requiredAccess: access,
      allowTestOnlyAccess: testOnlyAccess,
      referenceDictionary: referenceDictionary,
      errors: &errors
    )
  }
}

extension ActionPrototype {
  func lookupParameter(_ identifier: StrictString) -> ParameterIntermediate? {
    return parameters.parameter(named: identifier)
  }

  func parameterReferenceDictionary(externalLookup: [ReferenceDictionary]) -> ReferenceDictionary {
    var result = ReferenceDictionary()
    for parameter in parameters.inAnyOrder {
      if let execute = parameter.executeAction {
        _ = result.add(action: execute)
      } else {
        _ = result.add(action: parameter.passAction)
      }
    }

    result.resolveTypeIdentifiers(externalLookup: externalLookup)
    return result
  }

  func signature(orderedFor name: StrictString) -> [ParsedTypeReference] {
    return parameters.ordered(for: name).map({ $0.type })
  }
}

extension ActionPrototype {

  func requiredIdentifiers(
    referenceDictionary: ReferenceDictionary
  ) -> [StrictString] {
    var result: [StrictString] = []
    for parameter in parameters.inAnyOrder {
      result.append(
        contentsOf: parameter.type.requiredIdentifiers(
          referenceDictionary: referenceDictionary
        )
      )
    }
    if let value = returnValue {
      result.append(
        contentsOf: value.requiredIdentifiers(
          referenceDictionary: referenceDictionary
        )
      )
    }
    return result
  }
}
