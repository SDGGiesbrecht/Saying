import SDGLogic
import SDGCollections
import SDGText

struct ActionIntermediate {
  var names: Set<StrictString>
  var parameters: [ParameterIntermediate]
  var reorderings: [StrictString: [Int]]
  var returnValue: StrictString?
  var c: NativeActionImplementation?
  var cSharp: NativeActionImplementation?
  var javaScript: NativeActionImplementation?
  var kotlin: NativeActionImplementation?
  var swift: NativeActionImplementation?
  var implementation: ActionUse?
  var declaration: ParsedActionDeclaration?
  var coveredIdentifier: StrictString?
}

extension ActionIntermediate {

  static func construct(
    _ declaration: ParsedActionDeclaration
  ) -> Result<ActionIntermediate, ErrorList<ActionIntermediate.ConstructionError>> {
    var errors: [ActionIntermediate.ConstructionError] = []
    var names: Set<StrictString> = []
    var parameterIndices: [StrictString: Int] = [:]
    var parameterReferences: [StrictString: StrictString] = [:]
    let namesSyntax = declaration.name.names.names
    var foundTypeSignature = false
    for entry in namesSyntax {
      let signature = entry.name
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
    var parameterTypes: [StrictString] = []
    var reorderings: [StrictString: [Int]] = [:]
    var completeParameterIndexTable: [StrictString: Int] = parameterIndices
    for entry in namesSyntax {
      let signature = entry.name
      let signatureName = signature.name()
      for (position, parameter) in signature.parameters().enumerated() {
        switch parameter.type {
        case .type(let type):
          parameterTypes.append(type.identifierText())
          reorderings[signatureName, default: []].append(position)
        case .reference(let reference):
          var resolving = reference.name.identifierText()
          var checked: Set<StrictString> = []
          while let next = parameterReferences[resolving] {
            checked.insert(resolving)
            resolving = next
            if next ∈ checked {
              errors.append(.cyclicalParameterReference(parameter))
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
      return ParameterIntermediate(names: names, type: type)
    }
    var c: NativeActionImplementation?
    var cSharp: NativeActionImplementation?
    var javaScript: NativeActionImplementation?
    var kotlin: NativeActionImplementation?
    var swift: NativeActionImplementation?
    for implementation in declaration.implementation.implementations {
      switch NativeActionImplementation.construct(
        implementation: implementation.expression,
        indexTable: completeParameterIndexTable
      ) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeActionImplementation($0) }))
      case .success(let constructed):
        switch implementation.language.identifierText() {
        case "C":
          c = constructed
        case "C♯":
          cSharp = constructed
        case "JavaScript":
          javaScript = constructed
        case "Kotlin":
          kotlin = constructed
        case "Swift":
          swift = constructed
        default:
          errors.append(ConstructionError.unknownLanguage(implementation.language))
        }
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionIntermediate(
        names: names,
        parameters: parameters,
        reorderings: reorderings,
        returnValue: declaration.returnValue?.type.identifierText(),
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift,
        declaration: declaration
      )
    )
  }

  func validateReferences(module: ModuleIntermediate, errors: inout [ReferenceError]) {
    for parameter in parameters {
      let thing = parameter.type
      if module.lookupThing(thing) == nil {
        errors.append(.noSuchThing(thing))
      }
    }
    if let thing = self.returnValue,
       module.lookupThing(thing) == nil {
      errors.append(.noSuchThing(thing))
    }
  }
}

extension ActionIntermediate {
  func lookupParameter(_ identifier: StrictString) -> ParameterIntermediate? {
    return parameters.first(where: { $0.names.contains(identifier) })
  }
}

extension ActionIntermediate {

  var isCoverageWrapper: Bool {
    return coveredIdentifier ≠ nil
  }

  func coverageTrackingIdentifier() -> StrictString {
    return "☐\(names.identifier())"
  }
  func wrappedToTrackCoverage() -> ActionIntermediate? {
    if let coverageIdentifier = coverageRegionIdentifier() {
      return ActionIntermediate(
        names: [coverageTrackingIdentifier()],
        parameters: parameters,
        reorderings: reorderings,
        returnValue: returnValue,
        implementation: ActionUse(
          actionName: self.names.identifier(),
          arguments: self.parameters.map({ parameter in
            return ActionUse(
              actionName: parameter.names.identifier(),
              arguments: []
            )
          })
        ),
        coveredIdentifier: coverageIdentifier
      )
    } else {
      return nil
    }
  }

  func coverageRegionIdentifier() -> StrictString? {
    return names.identifier()
  }
}
