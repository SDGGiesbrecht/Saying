import SDGLogic
import SDGCollections
import SDGText

struct Ability {
  var names: Set<StrictString>
  var parameters: [Set<StrictString>]
  var parameterReorderings: [StrictString: [Int]]
  var identifierMapping: [StrictString: StrictString]
  var requirements: [StrictString: RequirementIntermediate]
  var clientAccess: Bool
  var testOnlyAccess: Bool
  var tests: [TestIntermediate]
  var declaration: ParsedAbilityDeclaration
}

extension Ability {

  static func construct(
    _ declaration: ParsedAbilityDeclaration
  ) -> Result<Ability, ErrorList<Ability.ConstructionError>> {
    var errors: [Ability.ConstructionError] = []
    var names: Set<StrictString> = []
    var parameterIndices: [StrictString: Int] = [:]
    var parameterReferences: [StrictString: StrictString] = [:]
    let namesSyntax = declaration.name.names.names
    var foundTypeSignature = false
    for entry in namesSyntax {
      let signature = entry.name
      names.insert(signature.name())
      var declaresTypes: Bool?
      let parameters = signature.parameters.parameters
      if parameters.isEmpty {
        foundTypeSignature = true
      }
      for (index, parameter) in parameters.enumerated() {
        let parameterName = parameter.name.identifierText()
        switch parameter {
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
          parameterReferences[parameterName] = reference.reference.name.identifierText()
        }
      }
    }
    var parameterInformation: [Void] = []
    var reorderings: [StrictString: [Int]] = [:]
    var completeParameterIndexTable: [StrictString: Int] = parameterIndices
    for entry in namesSyntax {
      let signature = entry.name
      let signatureName = signature.name()
      for (position, parameter) in signature.parameters.parameters.enumerated() {
        switch parameter {
        case .type:
          parameterInformation.append(())
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
    let parameterIntermediates = parameterInformation.enumerated().map { index, information in
      let names = Set(
        completeParameterIndexTable.keys
          .lazy.filter({ name in
            return completeParameterIndexTable[name] == index
          })
      )
      return names
    }
    var identifierMapping: [StrictString: StrictString] = [:]
    var requirements: [StrictString: RequirementIntermediate] = [:]
    var tests: [TestIntermediate] = []
    for requirementNode in declaration.requirements.requirements.requirements {
      let documentation = requirementNode.documentation
      let requirement: RequirementIntermediate
      #warning("Unknown namespace.")
      switch RequirementIntermediate.construct(requirementNode, namespace: [["???"]]) {
      case .failure(let nested):
        errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenRequirement($0) }))
        continue
      case .success(let constructed):
        requirement = constructed
      }
      let parameters = requirement.parameters.reduce(Set(), { $0 ∪ $1.names })
      let namespace = [requirement.names]
      let identifier = requirement.names.identifier()
      for name in requirement.names {
        if identifierMapping[name] ≠ nil {
          errors.append(ConstructionError.redeclaredIdentifier(name, [requirementNode, identifierMapping[identifier].flatMap({ requirements[$0] })!.declaration!]))
        }
        identifierMapping[name] = identifier
      }
      requirements[identifier] = requirement
      if let documentation = documentation {
        var testIndex = 1
        for element in documentation.documentation.entries.entries {
          switch element {
          case .parameter(let parameter):
            if parameter.name.identifierText() ∉ parameters {
              errors.append(ConstructionError.documentedParameterNotFound(parameter))
            }
          case .test(let test):
            tests.append(TestIntermediate(test, location: namespace, index: testIndex))
            testIndex += 1
          case .paragraph:
            break
          }
        }
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Ability(
        names: names,
        parameters: parameterIntermediates,
        parameterReorderings: reorderings,
        identifierMapping: identifierMapping,
        requirements: requirements,
        clientAccess: declaration.access?.keyword is ParsedClientsKeyword,
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        tests: tests,
        declaration: declaration
      )
    )
  }
}
