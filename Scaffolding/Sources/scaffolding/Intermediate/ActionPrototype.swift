import SDGLogic
import SDGCollections
import SDGText

struct ActionPrototype {
  var names: Set<StrictString>
  var namespace: [Set<StrictString>]
  var parameters: [ParameterIntermediate]
  var reorderings: [StrictString: [Int]]
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
    var names: Set<StrictString> = []
    var parameterIndices: [StrictString: Int] = [:]
    var parameterReferences: [StrictString: StrictString] = [:]
    let namesDictionary = declaration.name.names
    var foundTypeSignature = false
    for (_, signature) in namesDictionary {
      names.insert(signature.name())
      var declaresTypes: Bool?
      let parameters = signature.parameters()
      if parameters.isEmpty {
        foundTypeSignature = true
      }
      for (index, parameter) in parameters.enumerated() {
        let parameterName = parameter.name.name()
        switch parameter.type {
        case .type, .action:
          if index == 0,
            foundTypeSignature {
            errors.append(.multipleTypeSignatures(signature))
          }
          if declaresTypes == false {
            errors.append(.typeInReferenceSignature(parameter))
          }
          declaresTypes = true
          foundTypeSignature = true
          parameterIndices[parameterName] = index
        case .reference(let reference):
          if declaresTypes == true {
            errors.append(.referenceInTypeSignature(parameter))
          }
          declaresTypes = false
          parameterReferences[parameterName] = reference.name.name()
        }
      }
    }
    var parameterTypes: [ParsedTypeReference] = []
    var reorderings: [StrictString: [Int]] = [:]
    var completeParameterIndexTable: [StrictString: Int] = parameterIndices
    for (_, signature) in namesDictionary {
      var reordering: [Int] = []
      let signatureName = signature.name()
      for (position, parameter) in signature.parameters().enumerated() {
        switch parameter.type {
        case .type(let type):
          parameterTypes.append(ParsedTypeReference(type))
          reordering.append(position)
        case .action(let action):
          parameterTypes.append(ParsedTypeReference(action))
          reordering.append(position)
        case .reference(let reference):
          var resolving = reference.name.name()
          var checked: Set<StrictString> = []
          while let next = parameterReferences[resolving] {
            checked.insert(resolving)
            resolving = next
            if next ∈ checked {
              if parameterIndices[resolving] == nil {
                errors.append(.cyclicalParameterReference(parameter))
              }
              break
            }
          }
          if let index = parameterIndices[resolving] {
            reordering.append(index)
            completeParameterIndexTable[parameter.name.name()] = index
          } else {
            errors.append(.parameterNotFound(reference))
          }
        }
      }
      let existingReordering = reorderings[signatureName]
      if existingReordering == nil
        ∨ existingReordering == reordering {
        reorderings[signatureName] = reordering
      } else {
        errors.append(.rearrangedParameters(signature))
      }
    }
    let parameters = parameterTypes.enumerated().map { index, type in
      let names = Set(
        completeParameterIndexTable.keys
          .lazy.filter({ name in
            return completeParameterIndexTable[name] == index
          })
      )
      return ParameterIntermediate(names: names, type: type)
    }
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      let intermediateDocumentation = DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: namespace
          .appending(names)
      )
      attachedDocumentation = intermediateDocumentation
      let existingParameters = parameters.reduce(Set(), { $0 ∪ $1.names })
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
        reorderings: reorderings,
        returnValue: declaration.returnValueType.map({ ParsedTypeReference($0) }),
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation
      )
    )
  }

  func validateReferences(referenceDictionary: ReferenceDictionary, errors: inout [ReferenceError]) {
    for parameter in parameters {
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
    return parameters.first(where: { $0.names.contains(identifier) })
  }

  func parameterReferenceDictionary() -> ReferenceDictionary {
    var result = ReferenceDictionary()
    for parameter in parameters {
      let parameters: [ParameterIntermediate]
      let reorderings: [StrictString: [Int]]
      let returnValue: ParsedTypeReference?
      switch parameter.type {
      case .simple:
        parameters = []
        reorderings = [:]
        returnValue = parameter.type
      case .action(parameters: let parameterParameters, returnValue: let parameterReturnValue):
        parameters = parameterParameters.map({ parameter in
          return ParameterIntermediate(
            names: [],
            type: parameter
          )
        })
        #warning("Not implemented yet.")
        reorderings = [:]
        returnValue = parameterReturnValue
      }
      _ = result.add(action: ActionIntermediate.parameterAction(
        names: parameter.names,
        parameters: parameters,
        reorderings: reorderings,
        returnValue: returnValue
      ))
    }
    return result
  }

  func signature(orderedFor name: StrictString) -> [ParsedTypeReference] {
    guard let reordering = reorderings[name] else {
      return []
    }
    return reordering.map({ parameters[$0].type })
  }
}
