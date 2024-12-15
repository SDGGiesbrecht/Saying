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
      case .enumeration(let enumeration):
        let thing = try Thing.construct(enumeration, namespace: baseNamespace).get()
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
      let abilityIdentifier = ability.names.identifier()

      var extensionTypes: [StrictString: StrictString] = [:]
      for (index, parameter) in ability.parameters.ordered(for: extensionBlock.ability).enumerated() {
        let argument = extensionBlock.arguments[index]
        extensionTypes[argument.identifier] = parameter.names.identifier()
      }

      for thing in extensionBlock.things {
        referenceDictionary.modifyAbility(
          identifier: abilityIdentifier,
          transformation: { ability in
            ability.provisionThings.append(
              thing.resolvingExtensionContext(typeLookup: extensionTypes)
            )
          }
        )
      }
      for action in extensionBlock.actions {
        referenceDictionary.modifyAbility(
          identifier: abilityIdentifier,
          transformation: { ability in
            ability.provisionActions.append(
              action.resolvingExtensionContext(typeLookup: extensionTypes)
            )
          }
        )
      }
      for use in extensionBlock.uses {
        referenceDictionary.modifyAbility(
          identifier: abilityIdentifier,
          transformation: { ability in
            ability.provisionUses.append(
              use.resolvingExtensionContext(typeLookup: extensionTypes)
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
      resolve(use, errors: &errors)
    }

    for documentation in [
      referenceDictionary.allThings().lazy.compactMap({ $0.documentation }),
      referenceDictionary.allThings().lazy.flatMap({ $0.cases.compactMap({ $0.documentation }) }),
      referenceDictionary.allActions().lazy.compactMap({ $0.documentation })
    ].joined() {
      tests.append(contentsOf: documentation.tests)
    }

    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }
  mutating func resolve(_ use: UseIntermediate, errors: inout [ReferenceError]) {
    let identifier = use.ability
    guard let ability = referenceDictionary.lookupAbility(identifier: identifier) else {
      errors.append(.noSuchAbility(name: identifier, reference: use.declaration.use))
      return
    }

    var useTypes: [StrictString: ParsedTypeReference] = [:]
    for (index, parameter) in ability.parameters.ordered(for: use.ability).enumerated() {
      let argument = use.arguments[index]
      for name in parameter.names {
        useTypes[name] = argument
      }
    }
    let specializationNamespace: [Set<StrictString>] = ability.parameters
      .ordered(for: ability.names.identifier())
      .flatMap({ parameter in
        let components: [StrictString] = useTypes[parameter.names.identifier()]!
          .unresolvedGloballyUniqueIdentifierComponents()
        return components.map({ Set([$0]) })
      })

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
    for remaining in prototypeActions {
      errors.append(.noSuchRequirement(remaining.declaration! as! ParsedActionDeclaration))
    }

    for thing in ability.provisionThings {
      let specialized = thing.specializing(
        for: use,
        typeLookup: useTypes,
        specializationNamespace: specializationNamespace
      )
      _ = referenceDictionary.add(thing: specialized)
    }
    for action in ability.provisionActions {
      let specialized = action.specializing(
        for: use,
        typeLookup: useTypes,
        specializationNamespace: specializationNamespace
      )
      _ = referenceDictionary.add(action: specialized)
    }
    for use in ability.provisionUses {
      resolve(
        use.specializing(typeLookup: useTypes, specializationNamespace: specializationNamespace),
        errors: &errors
      )
    }
  }

  mutating func resolveTypeIdentifiers() {
    referenceDictionary.resolveTypeIdentifiers(externalLookup: [])
  }

  mutating func resolveTypes() {
    referenceDictionary.resolveTypes(parentContexts: [])
    for testIndex in tests.indices {
      var locals = ReferenceDictionary()
      for statementIndex in tests[testIndex].statements.indices {
        let statement = tests[testIndex].statements[statementIndex]
        tests[testIndex].statements[statementIndex].resolveTypes(
          context: nil,
          referenceLookup: [referenceDictionary, locals],
          finalReturnValue: .none
        )
        let newActions = statement.action.localActions()
        for local in newActions {
          _ = locals.add(action: local)
        }
        if !newActions.isEmpty {
          locals.resolveTypeIdentifiers(externalLookup: [referenceDictionary])
        }
      }
    }
  }

  func validateReferences() throws {
    var errors: [ReferenceError] = []
    referenceDictionary.validateReferencesAsModule(errors: &errors)
    for test in tests {
      var locals = ReferenceDictionary()
      for statement in test.statements {
        statement.validateReferences(
          context: [referenceDictionary].appending(locals),
          testContext: true,
          errors: &errors
        )
        let newActions = statement.action.localActions()
        for local in newActions {
          _ = locals.add(action: local)
        }
        if !newActions.isEmpty {
          locals.resolveTypeIdentifiers(externalLookup: [referenceDictionary])
        }
      }
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
      referenceDictionary: referenceDictionary.applyingTestCoverageTracking(externalLookup: []),
      uses: uses,
      tests: tests
    )
  }
}

extension ModuleIntermediate {
  func removingUnreachable(fromEntryPoints entryPoints: [StrictString]? = nil) -> ModuleIntermediate {
    #warning("Not implemented yet.")
    return ModuleIntermediate()
  }
}
