import SDGLogic
import SDGCollections
import SDGText

struct ModuleIntermediate {
  var identifierMapping: [StrictString: StrictString] = [:]
  var things: [StrictString: Thing] = [:]
  var actions: [StrictString: [[StrictString]: [StrictString?: ActionIntermediate]]] = [:]
  var abilities: [StrictString: Ability] = [:]
  var uses: [UseIntermediate] = []
  var tests: [TestIntermediate] = []
}

extension ModuleIntermediate: Scope {
  func lookupAction(
    _ identifier: StrictString,
    signature: [StrictString],
    specifiedReturnValue: StrictString??
  ) -> ActionIntermediate? {
    guard let mappedIdentifier = identifierMapping[identifier],
      let group = actions[mappedIdentifier] else {
      return nil
    }
    var mappedSignature: [StrictString] = []
    for element in signature {
      guard let mappedElement = identifierMapping[element] else {
        return nil
      }
      mappedSignature.append(mappedElement)
    }
    guard let returnOverloads = group[mappedSignature] else {
      return nil
    }
    switch specifiedReturnValue {
    case .some(.some(let value)):
      let mappedReturn = identifierMapping[value]
      return returnOverloads[mappedReturn]
    case .some(.none):
      return returnOverloads[.none]
    case .none:
      if returnOverloads.count == 1 {
        #warning("Debugging...")
        if identifier == "example",
          returnOverloads.values.first?.returnValue == "truth value" {
          print(mappedIdentifier, mappedSignature)
          print(group.keys)
          fatalError()
        }
        return returnOverloads.values.first
      } else {
        return nil
      }
    }
  }
}

extension ModuleIntermediate {

  func lookupThing(_ identifier: StrictString) -> Thing? {
    return identifierMapping[identifier].flatMap { things[$0] }
  }

  func lookupDeclaration(
    _ identifier: StrictString,
    signature: [StrictString],
    specifiedReturnValue: StrictString??
  ) -> ParsedDeclaration? {
    if signature == [],
      let thing = lookupThing(identifier)?.declaration {
      return .thing(thing)
    } else if let action = lookupAction(identifier, signature: signature, specifiedReturnValue: specifiedReturnValue)?.declaration as? ParsedActionDeclaration {
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
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name, signature: [], specifiedReturnValue: nil)!]))
          }
          identifierMapping[name] = identifier
        }
        things[identifier] = thing
      case .action(let actionNode):
        let action = try ActionIntermediate.construct(actionNode, namespace: baseNamespace).get()
        let identifier = action.names.identifier()
        for name in action.names {
          if identifierMapping[name] ≠ nil,
            identifierMapping[name] ≠ identifier {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name, signature: action.signature(orderedFor: name), specifiedReturnValue: action.returnValue)!]))
          }
          identifierMapping[name] = identifier
        }
        actions[identifier, default: [:]][action.signature(orderedFor: identifier), default: [:]][action.returnValue] = action
      case .ability(let abilityNode):
        let ability = try Ability.construct(abilityNode, namespace: baseNamespace).get()
        let identifier = ability.names.identifier()
        for name in ability.names {
          if identifierMapping[name] ≠ nil {
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name, signature: ability.parameters.map({ _ in "" }), specifiedReturnValue: nil)!]))
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
      let argumentReordering = ability.parameterReorderings[use.ability]!

      var useTypes: [StrictString: StrictString] = [:]
      var canonicallyOrderedUseArguments: [Set<StrictString>] = Array(repeating: [], count: argumentReordering.count)
      for (argumentindex, argument) in use.arguments.enumerated() {
        let parameterIndex = argumentReordering[argumentindex]
        let parameter = ability.parameters[parameterIndex]
        for name in parameter {
          useTypes[name] = argument
        }
        canonicallyOrderedUseArguments[parameterIndex] = [argument]
      }

      var prototypeActions = use.actions
      for (_, requirement) in ability.requirements {
        if let provisionIndex = prototypeActions.firstIndex(where: { action in
          return action.names.overlaps(requirement.names)
        }) {
          let provision = prototypeActions.remove(at: provisionIndex)
          switch provision.merging(requirement: requirement, useAccess: use.access) {
          case .success(let new):
            let identifier = new.names.identifier()
            for name in new.names {
              identifierMapping[name] = identifier
            }
            actions[identifier, default: [:]][new.signature(orderedFor: identifier), default: [:]][new.returnValue] = new
          case .failure(let error):
            errors.append(contentsOf: error.errors)
          }
        } else if let provision = ability.defaults[requirement.names.identifier()] {
          let identifier = provision.names.identifier()
          for name in provision.names {
            identifierMapping[name] = identifier
          }
          let specialized = provision.specializing(
            for: use,
            typeLookup: useTypes,
            canonicallyOrderedUseArguments: canonicallyOrderedUseArguments
          )
          actions[identifier, default: [:]][specialized.signature(orderedFor: identifier), default: [:]][specialized.returnValue] = specialized
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
      things.values.lazy.compactMap({ $0.documentation }) as [DocumentationIntermediate],
      actions.values
        .lazy.map({ $0.values })
        .joined()
        .lazy.map({ $0.values })
        .joined()
        .compactMap({ $0.documentation }) as [DocumentationIntermediate]
    ].joined() {
      tests.append(contentsOf: documentation.tests)
    }

    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }

  mutating func resolveTypeIdentifiers() {
    var newActions: [StrictString: [[StrictString]: [StrictString?: ActionIntermediate]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        let resolvedSignature = signature.map({ identifierMapping[$0] ?? $0 })
        for (overload, action) in returnOverloads {
          let resolvedReturn = overload.flatMap({ identifierMapping[$0] ?? $0 })
          newActions[actionName, default: [:]][resolvedSignature, default: [:]][resolvedReturn] = action
        }
      }
    }
    actions = newActions
  }

  mutating func resolveTypes() {
    var newActions: [StrictString: [[StrictString]: [StrictString?: ActionIntermediate]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        for (overload, action) in returnOverloads {
          var modified = action
          modified.implementation?.resolveTypes(context: action, module: self)
          newActions[actionName, default: [:]][signature, default: [:]][overload] = modified
        }
      }
    }
    actions = newActions
    for index in tests.indices {
      tests[index].action.resolveTypes(context: nil, module: self)
    }
  }

  func validateReferences() throws {
    var errors: [ReferenceError] = []
    for group in actions.values {
      for returnOverloads in group.values {
        for action in returnOverloads.values {
          action.validateReferences(module: self, errors: &errors)
        }
      }
    }
    for test in tests {
      test.action.validateReferences(context: [self], testContext: true, errors: &errors)
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
    for group in self.actions.values {
      for returnOverloads in group.values {
        for action in returnOverloads.values {
          if let wrapped = action.wrappedToTrackCoverage() {
            let identifier = wrapped.names.identifier()
            identifierMapping[identifier] = identifier
            let wrappedSignature = wrapped.signature(orderedFor: identifier)
              .map({ identifierMapping[$0] ?? $0 })
            let wrappedReturn = wrapped.returnValue.flatMap { identifierMapping[$0] ?? $0 }
            actions[identifier, default: [:]][wrappedSignature, default: [:]][wrappedReturn] = wrapped
          }
        }
      }
    }
    return ModuleIntermediate(
      identifierMapping: identifierMapping,
      things: things,
      actions: actions,
      abilities: abilities,
      uses: uses,
      tests: tests
    )
  }
}
