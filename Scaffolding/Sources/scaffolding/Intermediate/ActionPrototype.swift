import SDGLogic
import SDGCollections
import SDGText

struct ActionPrototype {
  var names: Set<StrictString>
  var parameters: [ParameterIntermediate]
  var reorderings: [StrictString: [Int]]
  var returnValue: StrictString?
  var clientAccess: Bool
  var testOnlyAccess: Bool

  var completeParameterIndexTable: [StrictString: Int]
  var declarationReturnValueType: ParsedUninterruptedIdentifier?
}

extension ActionPrototype {

  static func construct<S>(
    _ declaration: S
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
        let parameterName = parameter.name.identifierText()
        switch parameter.type {
        case .type:
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
          parameterReferences[parameterName] = reference.name.identifierText()
        }
      }
    }
    var parameterTypes: [ParsedUninterruptedIdentifier] = []
    var reorderings: [StrictString: [Int]] = [:]
    var completeParameterIndexTable: [StrictString: Int] = parameterIndices
    for (_, signature) in namesDictionary {
      let signatureName = signature.name()
      for (position, parameter) in signature.parameters().enumerated() {
        switch parameter.type {
        case .type(let type):
          parameterTypes.append(type)
          reorderings[signatureName, default: []].append(position)
        case .reference(let reference):
          var resolving = reference.name.identifierText()
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
            reorderings[signatureName, default: []].append(index)
            completeParameterIndexTable[parameter.name.identifierText()] = index
          } else {
            errors.append(.parameterNotFound(reference))
          }
        }
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
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionPrototype(
        names: names,
        parameters: parameters,
        reorderings: reorderings,
        returnValue: declaration.returnValueType?.identifierText(),
        clientAccess: declaration.access?.keyword is ParsedClientsKeyword,
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
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
      if self.clientAccess,
        ¬thing.clientAccess {
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
}
