import SDGLogic
import SDGCollections
import SDGText

struct ModuleIntermediate {
  var referenceDictionary = ReferenceDictionary()
  var uses: [UseIntermediate] = []
  var tests: [TestIntermediate] = []
  var languageNodes: [ParsedUninterruptedIdentifier] = []
}

extension ModuleIntermediate {

  mutating func add(file: ParsedDeclarationList) throws {
    languageNodes.append(contentsOf: file.findAllLanguageReferences())
    var errors: [ConstructionError] = []
    let baseNamespace: [Set<StrictString>] = []
    for declaration in file.declarations {
      switch declaration {
      case .language(let languageNode):
        if AccessIntermediate(languageNode.access) < .clients {
          errors.append(ConstructionError.restrictedLanguage(languageNode))
        }
        referenceDictionary.add(language: languageNode.name.identifierText())
      case .thing(let thingNode):
        let thing = try Thing.construct(thingNode, namespace: baseNamespace).get()
        errors.append(contentsOf: referenceDictionary.add(thing: thing).map({ .redeclaredIdentifier($0) }))
      case .action(let actionNode):
        let action = try ActionIntermediate.construct(actionNode, namespace: baseNamespace).get()
        errors.append(contentsOf: referenceDictionary.add(action: action).map({ .redeclaredIdentifier($0) }))
      case .ability(let abilityNode):
        let ability = try Ability.construct(abilityNode, namespace: baseNamespace).get()
        errors.append(contentsOf: referenceDictionary.add(ability: ability).map({ .redeclaredIdentifier($0) }))
      case .use(let use):
        let intermediate = try UseIntermediate.construct(use, namespace: baseNamespace).get()
        uses.append(intermediate)
      }
    }
    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }

  mutating func resolveUses() throws {
    var errors: [ReferenceError] = []
    for use in uses {
      let identifier = use.ability
      guard let ability = referenceDictionary.lookupAbility(identifier: identifier) else {
        errors.append(.noSuchAbility(name: identifier, reference: use.declaration.use))
        continue
      }
      let argumentReordering = ability.parameterReorderings[use.ability]!

      var useTypes: [StrictString: ParsedTypeReference] = [:]
      var canonicallyOrderedUseArguments: [Set<StrictString>] = Array(repeating: [], count: argumentReordering.count)
      for (argumentindex, argument) in use.arguments.enumerated() {
        let parameterIndex = argumentReordering[argumentindex]
        let parameter = ability.parameters[parameterIndex]
        for name in parameter {
          useTypes[name] = argument
        }
        canonicallyOrderedUseArguments[parameterIndex] = [argument.identifier]
      }

      var prototypeActions = use.actions
      for (_, requirement) in ability.requirements {
        if let provisionIndex = prototypeActions.firstIndex(where: { action in
          return action.names.overlaps(requirement.names)
        }) {
          let provision = prototypeActions.remove(at: provisionIndex)
          switch provision.merging(
            requirement: requirement,
            useAccess: use.access,
            typeLookup: useTypes,
            canonicallyOrderedUseArguments: canonicallyOrderedUseArguments
          ) {
          case .success(let new):
            _ = referenceDictionary.add(action: new)
          case .failure(let error):
            errors.append(contentsOf: error.errors)
          }
        } else if let provision = ability.defaults[requirement.names.identifier()] {
          let specialized = provision.specializing(
            for: use,
            typeLookup: useTypes,
            canonicallyOrderedUseArguments: canonicallyOrderedUseArguments
          )
          _ = referenceDictionary.add(action: specialized)
        } else {
          errors.append(.unfulfilledRequirement(name: requirement.names, use.declaration))
          continue
        }
      }
      for remaining in prototypeActions {
        errors.append(.noSuchRequirement(remaining.declaration! as! ParsedActionDeclaration))
      }
    }

    for documentation in [
      referenceDictionary.allThings().lazy.compactMap({ $0.documentation }),
      referenceDictionary.allActions().lazy.compactMap({ $0.documentation })
    ].joined() {
      tests.append(contentsOf: documentation.tests)
    }

    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }

  mutating func resolveTypeIdentifiers() {
    referenceDictionary.resolveTypeIdentifiers()
  }

  mutating func resolveTypes() {
    referenceDictionary.resolveTypes()
    for index in tests.indices {
      tests[index].action.resolveTypes(context: nil, referenceDictionary: referenceDictionary, specifiedReturnValue: .none)
    }
  }

  func validateReferences() throws {
    var errors: [ReferenceError] = []
    referenceDictionary.validateReferencesAsModule(errors: &errors)
    for test in tests {
      test.action.validateReferences(context: [referenceDictionary], testContext: true, errors: &errors)
    }
    for language in languageNodes {
      var identifier = language.identifierText()
      if identifier.hasSuffix(" +") {
        identifier.removeLast(2)
      }
      if ¬referenceDictionary.languageIsKnown(identifier) {
        errors.append(.noSuchLanguage(language))
      }
    }
    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }
}

extension ModuleIntermediate {

  func applyingTestCoverageTracking() -> ModuleIntermediate {
    return ModuleIntermediate(
      referenceDictionary: referenceDictionary.applyingTestCoverageTracking(),
      uses: uses,
      tests: tests
    )
  }
}
