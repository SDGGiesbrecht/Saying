import SDGLogic
import SDGCollections
import SDGText

struct Ability {
  var names: Set<StrictString>
  var parameters: [Set<StrictString>]
  var parameterReorderings: [StrictString: [Int]]
  var identifierMapping: [StrictString: StrictString]
  var requirements: [StrictString: RequirementIntermediate]
  var defaults: [StrictString: ActionIntermediate]
  var clientAccess: Bool
  var testOnlyAccess: Bool
  var documentation: DocumentationIntermediate?
  var declaration: ParsedAbilityDeclaration
}

extension Ability {

  static func construct(
    _ declaration: ParsedAbilityDeclaration,
    namespace: [Set<StrictString>]
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
    var defaults: [StrictString: ActionIntermediate] = [:]
    let abilityNamespace = namespace.appending(names)
    for requirementEntry in declaration.requirements.requirements.requirements {
      switch requirementEntry {
      case .requirement(let requirementNode):
        let requirement: RequirementIntermediate
        switch RequirementIntermediate.construct(requirementNode, namespace: abilityNamespace) {
        case .failure(let nested):
          errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenRequirement($0) }))
          continue
        case .success(let constructed):
          requirement = constructed
        }
        let identifier = requirement.names.identifier()
        for name in requirement.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [requirementNode, identifierMapping[identifier].flatMap({ requirements[$0] })!.declaration!]))
          }
          identifierMapping[name] = identifier
        }
        requirements[identifier] = requirement
      case .choice(let choiceNode):
        let requirement: RequirementIntermediate
        switch RequirementIntermediate.construct(choiceNode, namespace: abilityNamespace) {
        case .failure(let nested):
          errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenRequirement($0) }))
          continue
        case .success(let constructed):
          requirement = constructed
        }
        let identifier = requirement.names.identifier()
        for name in requirement.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [choiceNode, identifierMapping[identifier].flatMap({ requirements[$0] })!.declaration!]))
          }
          identifierMapping[name] = identifier
        }
        requirements[identifier] = requirement
        let defaultImplementation: ActionIntermediate
        switch ActionIntermediate.construct(choiceNode, namespace: abilityNamespace) {
        case .failure(let nested):
          errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenChoice($0) }))
          continue
        case .success(let constructed):
          defaultImplementation = constructed
        }
        defaults[identifier] = defaultImplementation
      }
    }
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      let intermediateDocumentation = DocumentationIntermediate.construct(documentation.documentation, namespace: namespace.appending(names))
      attachedDocumentation = intermediateDocumentation
      for parameter in intermediateDocumentation.parameters.joined() {
        errors.append(ConstructionError.documentedParameterNotFound(parameter))
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
        defaults: defaults,
        clientAccess: declaration.access?.keyword is ParsedClientsKeyword,
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}
