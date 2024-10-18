import SDGLogic
import SDGCollections
import SDGText

struct ModuleIntermediate {
  var identifierMapping: [StrictString: StrictString] = [:]
  var things: [StrictString: Thing] = [:]
  var actions: [StrictString: ActionIntermediate] = [:]
  var abilities: [StrictString: Ability] = [:]
  var uses: [UseIntermediate] = []
  var tests: [TestIntermediate] = []
}

extension ModuleIntermediate {

  func lookupThing(_ identifier: StrictString) -> Thing? {
    return identifierMapping[identifier].flatMap { things[$0] }
  }

  func lookupAction(_ identifier: StrictString) -> ActionIntermediate? {
    return identifierMapping[identifier].flatMap { actions[$0] }
  }

  func lookupDeclaration(_ identifier: StrictString) -> ParsedDeclaration? {
    if let thing = lookupThing(identifier)?.declaration {
      return .thing(thing)
    } else if let action = lookupAction(identifier)?.declaration {
      return .action(action)
    } else {
      return nil
    }
  }

  mutating func add(file: ParsedDeclarationList) throws {
    var errors: [ConstructionError] = []
    let baseNamespace: [Set<StrictString>] = []
    for declaration in file.declarations {
      switch declaration {
      case .thing(let thingNode):
        let thing = try Thing.construct(thingNode, namespace: baseNamespace).get()
        let identifier = thing.names.identifier()
        for name in thing.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
          }
          identifierMapping[name] = identifier
        }
        things[identifier] = thing
        if let documentation = thing.documentation {
          tests.append(contentsOf: documentation.tests)
        }
      case .action(let actionNode):
        let action = try ActionIntermediate.construct(actionNode, namespace: baseNamespace).get()
        let identifier = action.names.identifier()
        for name in action.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
          }
          identifierMapping[name] = identifier
        }
        actions[identifier] = action
        if let documentation = action.documentation {
          tests.append(contentsOf: documentation.tests)
        }
      case .ability(let abilityNode):
        let ability = try Ability.construct(abilityNode, namespace: baseNamespace).get()
        let identifier = ability.names.identifier()
        for name in ability.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
          }
          identifierMapping[name] = identifier
        }
        abilities[identifier] = ability
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
      guard let ability = abilities[identifier] else {
        errors.append(.noSuchAbility(name: identifier, reference: use.declaration.use))
        continue
      }
      var prototypeActions = use.actions
      for (_, requirement) in ability.requirements {
        guard let provisionIndex = prototypeActions.firstIndex(where: { action in
          return action.names.overlaps(requirement.names)
        }) else {
          errors.append(.unfulfilledRequirement(name: requirement.names, use.declaration))
          continue
        }
        let provision = prototypeActions.remove(at: provisionIndex)
        switch provision.merging(requirement: requirement) {
        case .success(let new):
          let identifier = new.names.identifier()
          for name in new.names {
            identifierMapping[name] = identifier
          }
          actions[identifier] = new
        case .failure(let error):
          errors.append(contentsOf: error.errors)
        }
      }
      for remaining in prototypeActions {
        errors.append(.noSuchRequirement(remaining.declaration!))
      }
    }
    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }

  func validateReferences() throws {
    var errors: [ReferenceError] = []
    for action in actions {
      action.value.validateReferences(module: self, errors: &errors)
    }
    for test in tests {
      test.action.validateReferences(module: self, testContext: true, errors: &errors)
    }
    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }
}

extension ModuleIntermediate {

  func applyingTestCoverageTracking() -> ModuleIntermediate {
    var identifierMapping = self.identifierMapping
    var actions = self.actions
    for (_, action) in self.actions {
      let wrappedIdentifier = action.coverageTrackingIdentifier()
      identifierMapping[wrappedIdentifier] = wrappedIdentifier
      actions[wrappedIdentifier] = action.wrappedToTrackCoverage()
    }
    return ModuleIntermediate(
      identifierMapping: identifierMapping,
      things: things,
      actions: actions,
      tests: tests
    )
  }
}
