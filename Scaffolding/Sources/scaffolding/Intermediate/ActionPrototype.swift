import SDGLogic
import SDGCollections
import SDGText

struct ActionPrototype {
  var names: Set<StrictString>
  var namespace: [Set<StrictString>]
  var parameters: [ParameterIntermediate]
  var reorderings: [StrictString: [Int]]
  var returnValue: StrictString?
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var documentation: DocumentationIntermediate?

  var completeParameterIndexTable: [StrictString: Int]
  var declarationReturnValueType: ParsedUninterruptedIdentifier?
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
    var parameterTypes: [ParsedUninterruptedIdentifier] = []
    var reorderings: [StrictString: [Int]] = [:]
    var completeParameterIndexTable: [StrictString: Int] = parameterIndices
    for (_, signature) in namesDictionary {
      var reordering: [Int] = []
      let signatureName = signature.name()
      for (position, parameter) in signature.parameters().enumerated() {
        switch parameter.type {
        case .type(let type):
          parameterTypes.append(type)
          reordering.append(position)
        case .action(let action):
          #warning("Not implemented yet.")
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
      return ParameterIntermediate(names: names, type: type.identifierText(), typeDeclaration: type)
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
        returnValue: declaration.returnValueType?.identifierText(),
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation,
        completeParameterIndexTable: completeParameterIndexTable,
        declarationReturnValueType: declaration.returnValueType
      )
    )
  }

  func validate(
    signatureType typeIdentifier: StrictString,
    reference: ParsedUninterruptedIdentifier?,
    module: ModuleIntermediate,
    errors: inout [ReferenceError]
  ) {
    if let thing = module.lookupThing(typeIdentifier) {
      if self.access > thing.access {
        errors.append(.thingAccessNarrowerThanSignature(reference: reference!))
      }
      if ¬self.testOnlyAccess,
        thing.testOnlyAccess {
        errors.append(.thingUnavailableOutsideTests(reference: reference!))
      }
    } else {
      errors.append(.noSuchThing(typeIdentifier, reference: reference!))
    }
  }

  func validateReferences(module: ModuleIntermediate, errors: inout [ReferenceError]) {
    for parameter in parameters {
      validate(
        signatureType: parameter.type,
        reference: parameter.typeDeclaration,
        module: module,
        errors: &errors
      )
    }
    if let thing = returnValue {
      validate(
        signatureType: thing,
        reference: declarationReturnValueType,
        module: module,
        errors: &errors
      )
    }
  }
}

extension ActionPrototype {
  func lookupParameter(_ identifier: StrictString) -> ParameterIntermediate? {
    return parameters.first(where: { $0.names.contains(identifier) })
  }

  func signature(orderedFor name: StrictString) -> [StrictString] {
    guard let reordering = reorderings[name] else {
      return []
    }
    return reordering.map({ parameters[$0].type })
  }
}
