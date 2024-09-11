import SDGLogic
import SDGCollections
import SDGText

struct ActionIntermediate {
  var names: Set<StrictString>
  var parameters: [ParameterIntermediate]
  var reorderings: [StrictString: [Int]]
  var returnValue: StrictString?
  var javaScript: JavaScriptImplementation?
  var swift: SwiftImplementation?
  var declaration: ParsedActionDeclaration?
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
    var javaScript: JavaScriptImplementation?
    var swift: SwiftImplementation?
    for implementation in declaration.implementation.implementations {
      switch implementation.language.identifierText() {
      case "JavaScript":
        switch JavaScriptImplementation.construct(
          implementation: implementation.expression,
          indexTable: completeParameterIndexTable
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenJavaScriptImplementation($0) }))
        case .success(let constructed):
          javaScript = constructed
        }
      case "Swift":
        switch SwiftImplementation.construct(
          implementation: implementation.expression,
          indexTable: completeParameterIndexTable
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenSwiftImplementation($0) }))
        case .success(let constructed):
          swift = constructed
        }
      default:
        errors.append(ConstructionError.unknownLanguage(implementation.language))
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
        javaScript: javaScript,
        swift: swift,
        declaration: declaration
      )
    )
  }

  func coverageRegions() -> Set<StrictString> {
    return [names.identifier()]
  }
}
