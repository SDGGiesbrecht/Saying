import SDGLogic
import SDGCollections
import SDGText

struct ModuleIntermediate {
  var identifierMapping: [StrictString: StrictString] = [:]
  var things: [StrictString: Thing] = [:]
  var actions: [StrictString: ActionIntermediate] = [:]
  var abilities: [StrictString: Ability] = [:]
  var applications: [ApplicationIntermediate] = []
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
    for declaration in file.declarations {
      let documentation: ParsedAttachedDocumentation?
      let parameters: Set<StrictString>
      let namespace: [Set<StrictString>]
      switch declaration {
      case .thing(let thingNode):
        documentation = thingNode.documentation
        parameters = []
        let thing = try Thing.construct(thingNode).get()
        namespace = [thing.names]
        let identifier = thing.names.identifier()
        for name in thing.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
          }
          identifierMapping[name] = identifier
        }
        things[identifier] = thing
      case .action(let actionNode):
        documentation = actionNode.documentation
        let action = try ActionIntermediate.construct(actionNode).get()
        parameters = action.parameters.reduce(Set(), { $0 ∪ $1.names })
        namespace = [action.names]
        let identifier = action.names.identifier()
        for name in action.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
          }
          identifierMapping[name] = identifier
        }
        actions[identifier] = action
      case .ability(let abilityNode):
        documentation = abilityNode.documentation
        parameters = []
        let ability = try Ability.construct(abilityNode).get()
        namespace = [ability.names]
        let identifier = ability.names.identifier()
        for name in ability.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
          }
          identifierMapping[name] = identifier
        }
        abilities[identifier] = ability
      case .application(let application):
        documentation = nil
        parameters = []
        namespace = []
        let intermediate = try ApplicationIntermediate.construct(application).get()
        applications.append(intermediate)
      }
      if let documentation = documentation {
        var testIndex = 1
        for element in documentation.documentation.entries.entries {
          switch element {
          case .parameter(let parameter):
            if parameter.name.identifierText() ∉ parameters {
              throw ConstructionError.parameterNotFound(parameter)
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
      throw ErrorList(errors)
    }
  }

  mutating func resolveApplications() throws {
    var errors: [ReferenceError] = []
    for application in applications {
      let identifier = application.ability
      guard let ability = abilities[identifier] else {
        errors.append(.noSuchAbility(name: identifier, reference: application.declaration.application))
        continue
      }
      var prototypeActions = application.actions
      for (_, requirement) in ability.requirements {
        guard let provisionIndex = prototypeActions.firstIndex(where: { action in
          return action.names.overlaps(requirement.names)
        }) else {
          errors.append(.unfulfilledRequirement(name: requirement.names, application.declaration))
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
