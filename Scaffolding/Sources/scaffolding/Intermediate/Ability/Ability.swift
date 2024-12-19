import SDGCollections
import SDGText

struct Ability {
  var names: Set<StrictString>
  var parameters: Interpolation<AbilityParameterIntermediate>
  var identifierMapping: [StrictString: StrictString]
  var requirements: [StrictString: RequirementIntermediate]
  var defaults: [StrictString: ActionIntermediate]
  var provisionThings: [Thing]
  var provisionActions: [ActionIntermediate]
  var provisionUses: [UseIntermediate]
  var access: AccessIntermediate
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
    let namesSyntax = declaration.name.names.names
    let parameters: Interpolation<AbilityParameterIntermediate>
    switch Interpolation.construct(
      entries: declaration.name.names.names,
      getEntryName: { $0.name.name() },
      getParameters: { $0.name.parameters.parameters },
      getParameterName: { $0.name.identifierText() },
      getDefinitionOrReference: { $0.definitionOrReference },
      getNestedSignature: { _ in nil },
      getNestedParameters: { _ in [] },
      constructParameter: { names, _, _ in AbilityParameterIntermediate(names: names) }
    ) {
    case .failure(let interpolationError):
      errors.append(contentsOf: interpolationError.errors.map({ .brokenParameterInterpolation($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      parameters = constructed
    }
    var names: Set<StrictString> = []
    for name in namesSyntax {
      names.insert(name.name.name())
    }
    var identifierMapping: [StrictString: StrictString] = [:]
    var requirements: [StrictString: RequirementIntermediate] = [:]
    var defaults: [StrictString: ActionIntermediate] = [:]
    let abilityNamespace = namespace.appending(names)
    for requirementEntry in declaration.requirements.requirements?.requirements.requirements ?? [] {
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
          if identifierMapping[name] != nil {
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
          if identifierMapping[name] != nil {
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
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Ability(
        names: names,
        parameters: parameters,
        identifierMapping: identifierMapping,
        requirements: requirements,
        defaults: defaults,
        provisionThings: [],
        provisionActions: [],
        provisionUses: [],
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}
