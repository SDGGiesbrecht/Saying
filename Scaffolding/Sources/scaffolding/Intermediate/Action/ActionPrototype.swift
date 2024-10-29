import SDGLogic
import SDGCollections
import SDGText

struct ActionPrototype {
  var names: Set<StrictString>
  var namespace: [Set<StrictString>]
  var parameters: Interpolation<ParameterIntermediate>
  var returnValue: ParsedTypeReference?
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var documentation: DocumentationIntermediate?
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
      constructParameter: { ParameterIntermediate(names: $0, type: $1) }
    ) {
    case .failure(let interpolationError):
      errors.append(contentsOf: interpolationError.errors.map({ .brokenParameterInterpolation($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      parameters = constructed
    }
    var names: Set<StrictString> = []
    for (_, signature) in namesDictionary {
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
        names: names,
        namespace: namespace,
        parameters: parameters,
        returnValue: declaration.returnValueType.map({ ParsedTypeReference($0) }),
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation
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

  func parameterReferenceDictionary() -> ReferenceDictionary {
    var result = ReferenceDictionary()
    for parameter in parameters.inAnyOrder {
      let parameters: Interpolation<ParameterIntermediate>
      let returnValue: ParsedTypeReference?
      switch parameter.type {
      case .simple:
        parameters = .empty(names: parameter.names)
        returnValue = parameter.type
      case .action(parameters: let parameterParameters, returnValue: let parameterReturnValue):
        #warning("Not implemented yet.")
        parameters = .empty(names: parameter.names)
        /*parameters = parameterParameters.map({ parameter in
          return ParameterIntermediate(
            names: [],
            type: parameter
          )
        })
        #warning("Static placeholders.")
        let placeholderReordering = Array(0..<parameterParameters.count)
        var stubReorderings: [StrictString: [Int]] = [:]
        for name in parameter.names {
          stubReorderings[name] = placeholderReordering
        }
        reorderings = stubReorderings*/
        returnValue = parameterReturnValue
      }
      _ = result.add(action: ActionIntermediate.parameterAction(
        names: parameter.names,
        parameters: parameters,
        returnValue: returnValue
      ))
    }
    return result
  }

  func signature(orderedFor name: StrictString) -> [ParsedTypeReference] {
    return parameters.ordered(for: name).map({ $0.type })
  }
}
