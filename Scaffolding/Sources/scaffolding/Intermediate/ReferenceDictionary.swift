import SDGLogic
import SDGCollections
import SDGText

struct ReferenceDictionary {
  private var languages: Set<StrictString>
  private var identifierMapping: [StrictString: StrictString]
  private var things: [StrictString: Thing]
  private var actions: [StrictString: [[StrictString]: [StrictString?: ActionIntermediate]]]
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
  func resolve(identifier: StrictString) -> StrictString {
    return identifierMapping[identifier] ?? identifier
  }

  func lookupDeclaration(
    _ identifier: StrictString,
    signature: [TypeReference?],
    specifiedReturnValue: TypeReference??
  ) -> ParsedDeclaration? {
    if signature.isEmpty,
       let thing = lookupThing(identifier)?.declaration {
      return .thing(thing)
    } else if let fullSignature = signature.mapAll({ $0 }),
              let action = lookupAction(identifier, signature: fullSignature, specifiedReturnValue: specifiedReturnValue)?.declaration as? ParsedActionDeclaration {
      return .action(action)
    } else {
      return nil
    }
  }
}

extension ReferenceDictionary {
  mutating func add(thing: Thing) -> [RedeclaredIdentifierError] {
    var errors: [RedeclaredIdentifierError] = []
    let identifier = thing.names.identifier()
    for name in thing.names {
      if identifierMapping[name] ≠ nil {
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: .thing(thing.declaration), conflictingDeclarations: [lookupDeclaration(name, signature: [], specifiedReturnValue: nil)!]))
      }
      identifierMapping[name] = identifier
    }
    things[identifier] = thing
    return errors
  }

  func lookupThing(_ identifier: StrictString) -> Thing? {
    return identifierMapping[identifier].flatMap { things[$0] }
  }

  func allThings() -> [Thing] {
    return Array(things.values)
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
    actions[identifier, default: [:]][action.signature(orderedFor: identifier).map({ $0.identifier}), default: [:]][action.returnValue?.identifier] = action
    return errors
  }

  func lookupAction(
    _ identifier: StrictString,
    signature: [TypeReference],
    specifiedReturnValue: TypeReference??
  ) -> ActionIntermediate? {
    guard let mappedIdentifier = identifierMapping[identifier],
      let group = actions[mappedIdentifier] else {
      return nil
    }
    var mappedSignature: [StrictString] = []
    for element in signature {
      guard let mappedElement = identifierMapping[element.identifier] else {
        return nil
      }
      mappedSignature.append(mappedElement)
    }
    guard let returnOverloads = group[mappedSignature] else {
      return nil
    }
    switch specifiedReturnValue {
    case .some(.some(let value)):
      let mappedReturn = identifierMapping[value.identifier]
      return returnOverloads[mappedReturn]
    case .some(.none):
      return returnOverloads[.none]
    case .none:
      if returnOverloads.count == 1 {
        return returnOverloads.values.first
      } else {
        return nil
      }
    }
  }

  func allActions(sorted: Bool = false) -> [ActionIntermediate] {
    var result =
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
        dictionary[entry.globallyUniqueIdentifier(referenceDictionary: self)] = entry
      }
      return dictionary.keys.sorted().map({ dictionary[$0]! })
    }
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupAction(
    _ identifier: StrictString,
    signature: [TypeReference],
    specifiedReturnValue: TypeReference??
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
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: .ability(ability.declaration), conflictingDeclarations: [lookupDeclaration(name, signature: ability.parameters.map({ _ in nil }), specifiedReturnValue: nil)!]))
      }
      identifierMapping[name] = identifier
    }
    abilities[identifier] = ability
    return errors
  }

  func lookupAbility(identifier: StrictString) -> Ability? {
    return abilities[resolve(identifier: identifier)]
  }

  func allAbilities() -> [Ability] {
    return Array(abilities.values)
  }
}

extension ReferenceDictionary {
  mutating func resolveTypeIdentifiers() {
    var newActions: [StrictString: [[StrictString]: [StrictString?: ActionIntermediate]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        let resolvedSignature = signature.map({ resolve(identifier: $0) })
        for (overload, action) in returnOverloads {
          let resolvedReturn = overload.flatMap({ resolve(identifier: $0 ) })
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
          modified.implementation?.resolveTypes(
            context: action,
            referenceDictionary: self,
            specifiedReturnValue: action.returnValue
          )
          newActions[actionName, default: [:]][signature, default: [:]][overload] = modified
        }
      }
    }
    actions = newActions
  }

  func validateReferencesAsModule(errors: inout [ReferenceError]) {
    for group in actions.values {
      for returnOverloads in group.values {
        for action in returnOverloads.values {
          action.validateReferences(moduleReferenceDictionary: self, errors: &errors)
        }
      }
    }
  }
}

extension ReferenceDictionary {

  func applyingTestCoverageTracking() -> ReferenceDictionary {
    var new = self
    for action in allActions() {
      if let wrapped = action.wrappedToTrackCoverage(referenceDictionary: self) {
        _ = new.add(action: wrapped)
      }
    }
    #warning("Are either of these necessary?")
    new.resolveTypeIdentifiers()
    new.resolveTypes()
    return new
  }
}
