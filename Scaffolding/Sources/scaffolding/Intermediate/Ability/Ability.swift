struct Ability {
  var names: Set<UnicodeText>
  var parameters: Interpolation<AbilityParameterIntermediate>
  var identifierMapping: [UnicodeText: MappedIdentifier]
  var requirements: [UnicodeText: [[TypeReference]: [TypeReference?: RequirementIntermediate]]]
  var defaults: [UnicodeText: ActionIntermediate]
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
    namespace: [Set<UnicodeText>]
  ) -> Result<Ability, ErrorList<Ability.ConstructionError>> {
    var errors: [Ability.ConstructionError] = []
    let namesDictionary = declaration.name.namesDictionary
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
    var names: Set<UnicodeText> = []
    for (_, signature) in namesDictionary {
      let name = signature.name()
      names.insert(name)
    }
    var identifierMapping: [UnicodeText: MappedIdentifier] = [:]
    var requirements: [UnicodeText: [[TypeReference]: [TypeReference?: RequirementIntermediate]]] = [:]
    var defaults: [UnicodeText: ActionIntermediate] = [:]
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
          if identifierMapping[name] != nil,
            identifierMapping[name]?.identifier != identifier {
            errors.append(ConstructionError.redeclaredIdentifier(name, [requirementNode, identifierMapping[identifier].flatMap({ requirements[$0.identifier]?[requirement.signature(orderedFor: identifier).map({ $0.key })]![requirement.returnValue?.key] })!.declaration!]))
          }
          identifierMapping[name] = MappedIdentifier(identifier: identifier, reordering: requirement.parameters.reordering(from: name, to: identifier))
        }
        requirements[identifier, default: [:]][requirement.signature(orderedFor: identifier).map({ $0.key }), default: [:]][requirement.returnValue?.key] = requirement
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
          if identifierMapping[name] != nil,
            identifierMapping[name]?.identifier != identifier {
            errors.append(ConstructionError.redeclaredIdentifier(name, [choiceNode, identifierMapping[identifier].flatMap({ requirements[$0.identifier]?[requirement.signature(orderedFor: identifier).map({ $0.key })]![requirement.returnValue?.key] })!.declaration!]))
          }
          identifierMapping[name] = MappedIdentifier(identifier: identifier, reordering: requirement.parameters.reordering(from: name, to: identifier))
        }
        requirements[identifier, default: [:]][requirement.signature(orderedFor: identifier).map({ $0.key }), default: [:]][requirement.returnValue?.key] = requirement
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
    let access = AccessIntermediate(declaration.access)
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      switch DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: namespace.appending(names),
        inheritedVisibility: access
      ) {
      case .failure(let nested):
        errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenDocumentation($0) }))
      case .success(let intermediateDocumentation):
        attachedDocumentation = intermediateDocumentation
        for parameter in intermediateDocumentation.parameters.joined() {
          errors.append(ConstructionError.documentedParameterNotFound(parameter))
        }
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
        access: access,
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}
