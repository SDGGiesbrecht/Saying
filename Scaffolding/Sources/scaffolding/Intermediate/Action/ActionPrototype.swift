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
  var swiftName: UnicodeText?

  init(
    isFlow: Bool,
    names: Set<StrictString>,
    namespace: [Set<StrictString>],
    parameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference?,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    documentation: DocumentationIntermediate?,
    swiftName: UnicodeText?
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
    var parameters: Interpolation<ParameterIntermediate>
    switch Interpolation.construct(
      entries: namesDictionary.values,
      getEntryName: { $0.name() },
      getParameters: { $0.parameters() },
      getParameterName: { $0.name.name() },
      getDefinitionOrReference: { $0.definitionOrReference },
      getNestedSignature: { $0.name },
      getNestedParameters: { $0.parameters() },
      constructParameter: { ParameterIntermediate(names: $0, nestedParameters: $1!, returnValue: $2.type, isThrough: $2.isThrough, swiftLabel: nil) }
    ) {
    case .failure(let interpolationError):
      errors.append(contentsOf: interpolationError.errors.map({ .brokenParameterInterpolation($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      parameters = constructed
    }
    var names: Set<StrictString> = []
    var swiftName: UnicodeText?
    for (language, signature) in namesDictionary {
      let name = signature.name()
      if language == "Swift" {
        swiftName = name
        let parameterList = StrictString(name).dropping(through: " ")
        let labels = parameterList.components(separatedBy: "()").dropLast()
          .map({ component in
            var label = StrictString(component.contents)
            if label.first == " " {
              label.removeFirst()
            }
            if label.last == " " {
              label.removeLast()
            }
            return label
          })
        parameters.apply(swiftLabels: labels.map({ UnicodeText($0) }), accordingTo: name)
      }
      names.insert(StrictString(name))
    }
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      let intermediateDocumentation = DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: namespace
          .appending(names)
      )
      attachedDocumentation = intermediateDocumentation
      let existingParameters = parameters.inAnyOrder.reduce(Set(), { $0.union($1.names) })
      for parameter in intermediateDocumentation.parameters.joined() {
        if !existingParameters.contains(StrictString(parameter.name.identifierText())) {
          errors.append(ConstructionError.documentedParameterNotFound(parameter))
        }
      }
    }
    if !errors.isEmpty {
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

  func validateReferences(referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    for parameter in parameters.inAnyOrder {
      parameter.type.validateReferences(
        requiredAccess: access,
        allowTestOnlyAccess: testOnlyAccess,
        referenceLookup: referenceLookup,
        errors: &errors
      )
    }
    returnValue?.validateReferences(
      requiredAccess: access,
      allowTestOnlyAccess: testOnlyAccess,
      referenceLookup: referenceLookup,
      errors: &errors
    )
  }
}

extension ActionPrototype {
  func lookupParameter(_ identifier: UnicodeText) -> ParameterIntermediate? {
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

  func signature(orderedFor name: UnicodeText) -> [ParsedTypeReference] {
    return parameters.ordered(for: name).map({ $0.type })
  }
}

extension ActionPrototype {

  func requiredIdentifiers(
    moduleAndExternalReferenceLookup: [ReferenceDictionary]
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
    for parameter in parameters.inAnyOrder {
      result.append(
        contentsOf: parameter.type.requiredIdentifiers(
          moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
        )
      )
    }
    if let value = returnValue {
      result.append(
        contentsOf: value.requiredIdentifiers(
          moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
        )
      )
    }
    return result
  }
}
