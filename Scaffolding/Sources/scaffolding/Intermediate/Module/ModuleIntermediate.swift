import SDGLogic
import SDGCollections
import SDGText

struct ModuleIntermediate {
  var referenceDictionary = ReferenceDictionary()
  var uses: [UseIntermediate] = []
  var extensions: [ExtensionIntermediate] = []
  var tests: [TestIntermediate] = []
  var languageNodes: [ParsedUninterruptedIdentifier] = []
}

extension ModuleIntermediate {
  func allTests(sorted: Bool = false) -> [TestIntermediate] {
    if ¬sorted {
      return tests
    } else {
      var dictionary: [StrictString: TestIntermediate] = [:]
      for entry in tests {
        dictionary[entry.location.map({ $0.identifier() }).joined(separator: ":")] = entry
      }
      return dictionary.keys.sorted().map({ dictionary[$0]! })
    }
  }
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
      case .extensionSyntax(let extensionSyntax):
        let intermediate = try ExtensionIntermediate.construct(extensionSyntax, namespace: baseNamespace).get()
        extensions.append(intermediate)
      }
    }
    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }

  mutating func resolveExtensions() throws {
    var errors: [ReferenceError] = []
    for extensionBlock in extensions {
      let identifier = extensionBlock.ability
      guard let ability = referenceDictionary.lookupAbility(identifier: identifier) else {
        errors.append(.noSuchAbility(name: identifier, reference: extensionBlock.declaration.ability))
        continue
      }

      var extensionTypes: [StrictString: SimpleTypeReference] = [:]
      for (index, parameter) in ability.parameters.ordered(for: extensionBlock.ability).enumerated() {
        let argument = extensionBlock.arguments[index]
        for name in parameter.names {
          extensionTypes[name] = argument
        }
      }

      for thing in extensionBlock.things {
        referenceDictionary.modifyAbility(
          identifier: ability.names.identifier(),
          transformation: { ability in
            ability.provisionThings.append(
              thing.resolvingExtensionContext(
                typeLookup: extensionTypes
              )
            )
          }
        )
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
      
      var useTypes: [StrictString: SimpleTypeReference] = [:]
      for (index, parameter) in ability.parameters.ordered(for: use.ability).enumerated() {
        let argument = use.arguments[index]
        for name in parameter.names {
          useTypes[name] = argument
        }
      }
      let specializationNamespace: [Set<StrictString>] = ability.parameters
        .ordered(for: ability.names.identifier())
        .map { [useTypes[$0.names.identifier()]!.identifier] }

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
            specializationNamespace: specializationNamespace
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
            specializationNamespace: specializationNamespace
          )
          _ = referenceDictionary.add(action: specialized)
        } else {
          errors.append(.unfulfilledRequirement(name: requirement.names, use.declaration))
          continue
        }
      }
      for thing in ability.provisionThings {
        let specialized = thing.specializing(
          for: use,
          typeLookup: useTypes,
          specializationNamespace: specializationNamespace
        )
        _ = referenceDictionary.add(thing: specialized)
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
