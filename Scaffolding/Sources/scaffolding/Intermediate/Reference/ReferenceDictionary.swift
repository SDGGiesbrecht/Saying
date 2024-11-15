import SDGLogic
import SDGCollections
import SDGText

struct ReferenceDictionary {
  private var languages: Set<StrictString>
  private var identifierMapping: [StrictString: StrictString]
  private var things: [StrictString: [[TypeReference]: Thing]]
  private var actions: [StrictString: [[TypeReference]: [TypeReference?: ActionIntermediate]]]
  private var abilities: [StrictString: Ability]
}

extension ReferenceDictionary {
  init() {
    self.init(
      languages: [],
      identifierMapping: [:],
      things: [:],
      actions: [:],
      abilities: [:]
    )
  }
}

extension ReferenceDictionary {
  mutating func add(language: StrictString) {
    languages.insert(language)
  }

  func languageIsKnown(_ language: StrictString) -> Bool {
    return language ∈ self.languages
  }
}

extension ReferenceDictionary {
  func resolveIfKnown(identifier: StrictString) -> StrictString? {
    return identifierMapping[identifier]
  }
  func resolve(identifier: StrictString) -> StrictString {
    return resolveIfKnown(identifier: identifier) ?? identifier
  }

  func lookupDeclaration(
    _ identifier: StrictString,
    signature: [ParsedTypeReference?],
    specifiedReturnValue: ParsedTypeReference??
  ) -> ParsedDeclaration? {
    if signature.isEmpty,
      let thing = lookupThing(identifier, components: [])?.declaration {
      return .thing(thing)
    } else if let fullSignature = signature.mapAll({ $0 }),
      let action = lookupAction(identifier, signature: fullSignature, specifiedReturnValue: specifiedReturnValue)?.declaration as? ParsedActionDeclaration {
      return .action(action)
    } else {
      return nil
    }
  }
}
extension Array where Element == ReferenceDictionary {
  func resolve(identifier: StrictString) -> StrictString {
    for scope in reversed() {
      if let found = scope.resolveIfKnown(identifier: identifier) {
        return found
      }
    }
    return identifier
  }
}

extension ReferenceDictionary {
  mutating func add(thing: Thing) -> [RedeclaredIdentifierError] {
    var errors: [RedeclaredIdentifierError] = []
    let identifier = thing.names.identifier()
    for name in thing.names {
      if identifierMapping[name] ≠ nil,
        identifierMapping[name] ≠ identifier {
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: .thing(thing.declaration), conflictingDeclarations: [lookupDeclaration(name, signature: [], specifiedReturnValue: nil)!]))
      }
      identifierMapping[name] = identifier
    }
    let parameters: [TypeReference] = thing.parameters.ordered(for: identifier)
      .map({ .simple($0.names.identifier()) })
    things[identifier, default: [:]][parameters] = thing
    return errors
  }

  func lookupThing(_ identifier: StrictString, components: [TypeReference]) -> Thing? {
    guard let mappedIdentifier = identifierMapping[identifier],
      let group = things[mappedIdentifier] else {
      return nil
    }
    let mappedComponents = components.map({ $0.resolving(fromReferenceLookup: [self]) })
    return group[mappedComponents]
  }

  func allThings() -> [Thing] {
    let result =
    things.values
      .lazy.map({ $0.values })
      .joined()
    return Array(result)
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupThing(_ identifier: StrictString, components: [TypeReference]) -> Thing? {
    for scope in reversed() {
      if let found = scope.lookupThing(identifier, components: components) {
        return found
      }
    }
    return nil
  }
}

extension ReferenceDictionary {
  mutating func add(action: ActionIntermediate) -> [RedeclaredIdentifierError] {
    var errors: [RedeclaredIdentifierError] = []
    let identifier = action.names.identifier()
    for name in action.names {
      if identifierMapping[name] ≠ nil,
        identifierMapping[name] ≠ identifier {
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: .action(action.declaration as! ParsedActionDeclaration), conflictingDeclarations: [lookupDeclaration(name, signature: action.signature(orderedFor: name), specifiedReturnValue: action.returnValue)!]))
      }
      identifierMapping[name] = identifier
    }
    actions[identifier, default: [:]][action.signature(orderedFor: identifier).map({ $0.key }), default: [:]][action.returnValue?.key] = action
    return errors
  }

  func referenceActions(
    from overloads: [[TypeReference] : [TypeReference? : ActionIntermediate]]
  ) -> [TypeReference? : ActionIntermediate] {
    var result: [TypeReference?: ActionIntermediate] = [:]
    for (signature, returnOverloads) in overloads {
      for (returnValue, action) in returnOverloads {
        let actionType = TypeReference.action(parameters: signature, returnValue: returnValue)
        result[actionType] = action.asReference()
      }
    }
    return result
  }
  func lookupAction(
    _ identifier: StrictString,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??
  ) -> ActionIntermediate? {
    guard let mappedIdentifier = identifierMapping[identifier],
      let group = actions[mappedIdentifier] else {
      return nil
    }
    let mappedSignature = signature.map({ $0.key.resolving(fromReferenceLookup: [self]) })
    let returnOverloads: [() -> [TypeReference?: ActionIntermediate]]
    switch ActionUse.isReferenceNotCall(name: identifier, arguments: mappedSignature) {
    case .some(true):
      returnOverloads = [{ referenceActions(from: group) }]
    case .some(false):
      returnOverloads = [{ group[mappedSignature] ?? [:] }]
    case .none:
      returnOverloads = [{ group[mappedSignature] ?? [:] }, { referenceActions(from: group) }]
    }
    for set in returnOverloads.lazy.map({ $0() }) {
      switch specifiedReturnValue {
      case .some(.some(let value)):
        let mappedReturn = value.key.resolving(fromReferenceLookup: [self])
        if let result = set[mappedReturn] {
          return result
        }
      case .some(.none):
        if let result = set[.none] {
          return result
        }
      case .none:
        if set.count == 1 {
          return set.values.first
        }
      }
    }
    return nil
  }

  func allActions(sorted: Bool = false) -> [ActionIntermediate] {
    let result =
    actions.values
      .lazy.map({ $0.values })
      .joined()
      .lazy.map({ $0.values })
      .joined()
    if ¬sorted {
      return Array(result)
    } else {
      var dictionary: [StrictString: ActionIntermediate] = [:]
      for entry in result {
        dictionary[entry.globallyUniqueIdentifier(referenceLookup: [self])] = entry
      }
      return dictionary.keys.sorted().map({ dictionary[$0]! })
    }
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupAction(
    _ identifier: StrictString,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??
  ) -> ActionIntermediate? {
    for scope in reversed() {
      if let found = scope.lookupAction(
        identifier,
        signature: signature,
        specifiedReturnValue: specifiedReturnValue
      ) {
        return found
      }
    }
    return nil
  }
}

extension ReferenceDictionary {
  mutating func add(ability: Ability) -> [RedeclaredIdentifierError] {
    var errors: [RedeclaredIdentifierError] = []
    let identifier = ability.names.identifier()
    for name in ability.names {
      if identifierMapping[name] ≠ nil {
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: .ability(ability.declaration), conflictingDeclarations: [lookupDeclaration(name, signature: ability.parameters.ordered(for: name).map({ _ in nil }), specifiedReturnValue: nil)!]))
      }
      identifierMapping[name] = identifier
    }
    abilities[identifier] = ability
    return errors
  }

  func lookupAbility(identifier: StrictString) -> Ability? {
    return abilities[resolve(identifier: identifier)]
  }
  mutating func modifyAbility(identifier: StrictString, transformation: (inout Ability) -> Void) {
    let realIdentifier = identifierMapping[identifier] ?? identifier
    transformation(&abilities[realIdentifier]!)
  }

  func allAbilities() -> [Ability] {
    return Array(abilities.values)
  }
}

extension ReferenceDictionary {
  mutating func resolveTypeIdentifiers() {
    var newThings: [StrictString: [[TypeReference]: Thing]] = [:]
    for (thingName, group) in things {
      for (signature, thing) in group {
        let resolvedSignature = signature.map({ $0.resolving(fromReferenceLookup: [self]) })
        newThings[thingName, default: [:]][resolvedSignature] = thing
      }
    }
    things = newThings
    
    var newActions: [StrictString: [[TypeReference]: [TypeReference?: ActionIntermediate]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        let resolvedSignature = signature.map({ $0.resolving(fromReferenceLookup: [self]) })
        for (overload, action) in returnOverloads {
          let resolvedReturn = overload.flatMap({ $0.resolving(fromReferenceLookup: [self]) })
          newActions[actionName, default: [:]][resolvedSignature, default: [:]][resolvedReturn] = action
        }
      }
    }
    actions = newActions
  }

  mutating func resolveTypes() {
    var newActions: [StrictString: [[TypeReference]: [TypeReference?: ActionIntermediate]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        for (overload, action) in returnOverloads {
          var modified = action
          modified.implementation?.resolveTypes(
            context: action,
            referenceDictionary: self,
            finalReturnValue: action.returnValue
          )
          newActions[actionName, default: [:]][signature, default: [:]][overload] = modified
        }
      }
    }
    actions = newActions
  }

  func validateReferencesAsModule(errors: inout [ReferenceError]) {
    for thing in allThings() {
      thing.documentation?.validateReferences(referenceLookup: [self], errors: &errors)
    }
    for action in allActions() {
      action.validateReferences(moduleReferenceDictionary: self, errors: &errors)
    }
    for ability in allAbilities() {
      ability.documentation?.validateReferences(referenceLookup: [self], errors: &errors)
    }
  }
}

extension ReferenceDictionary {

  func applyingTestCoverageTracking() -> ReferenceDictionary {
    var new = self
    for action in allActions() {
      if let wrapped = action.wrappedToTrackCoverage(referenceLookup: [self]) {
        _ = new.add(action: wrapped)
      }
    }
    new.resolveTypeIdentifiers()
    return new
  }
}
