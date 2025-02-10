import SDGText

struct ReferenceDictionary {
  private var languages: Set<StrictString>
  private var identifierMapping: [StrictString: UnicodeText]
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
  mutating func add(language: UnicodeText) {
    languages.insert(StrictString(language))
  }

  func languageIsKnown(_ language: UnicodeText) -> Bool {
    return self.languages.contains(StrictString(language))
  }
}

extension ReferenceDictionary {
  func resolveIfKnown(identifier: UnicodeText) -> UnicodeText? {
    return identifierMapping[StrictString(identifier)]
  }
  func resolve(identifier: UnicodeText) -> UnicodeText {
    return resolveIfKnown(identifier: identifier) ?? identifier
  }

  func lookupDeclaration(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference?],
    specifiedReturnValue: ParsedTypeReference??,
    parentContexts: [ReferenceDictionary]
  ) -> ParsedDeclaration? {
    if signature.isEmpty,
      let thing = lookupThing(identifier, components: [])?.declaration.genericDeclaration {
      return thing
    } else if let fullSignature = signature.mapAll({ $0 }),
      let action = lookupAction(identifier, signature: fullSignature, specifiedReturnValue: specifiedReturnValue, parentContexts: parentContexts)?.declaration as? ParsedActionDeclaration {
      return .action(action)
    } else {
      return nil
    }
  }
}
extension Array where Element == ReferenceDictionary {
  func resolve(identifier: UnicodeText) -> UnicodeText {
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
      if identifierMapping[StrictString(name)] != nil,
        identifierMapping[StrictString(name)].map({ StrictString($0) }) != StrictString(identifier) {
        errors.append(RedeclaredIdentifierError(identifier: UnicodeText(name), triggeringDeclaration: thing.declaration.genericDeclaration, conflictingDeclarations: [lookupDeclaration(UnicodeText(name), signature: [], specifiedReturnValue: nil, parentContexts: [])!]))
      }
      identifierMapping[name] = identifier
    }
    let parameters: [TypeReference] = thing.parameters.ordered(for: identifier)
      .map({ $0.resolvedType!.key })
    things[StrictString(identifier), default: [:]][parameters] = thing
    for part in thing.parts {
      errors.append(contentsOf: add(action: part.referenceAction))
      errors.append(contentsOf: add(action: part.accessor))
    }
    for enumerationCase in thing.cases {
      if let action = enumerationCase.referenceAction {
        errors.append(contentsOf: add(action: action))
      }
      errors.append(contentsOf: add(action: enumerationCase.wrapAction))
      if let action = enumerationCase.unwrapAction {
        errors.append(contentsOf: add(action: action))
      }
      errors.append(contentsOf: add(action: enumerationCase.checkAction))
    }
    return errors
  }

  func lookupThing(_ identifier: UnicodeText, components: [TypeReference]) -> Thing? {
    guard let mappedIdentifier = identifierMapping[StrictString(identifier)],
      let group = things[StrictString(mappedIdentifier)] else {
      return nil
    }
    let mappedComponents = components.map({ $0.resolving(fromReferenceLookup: [self]) })
    return group[mappedComponents]
  }
  func lookupThing(_ reference: TypeReference) -> Thing? {
    switch reference {
    case .simple(let simple):
      return lookupThing(UnicodeText(simple), components: [])
    case .compound(identifier: let identifier, components: let components):
      return lookupThing(UnicodeText(identifier), components: components.map({ $0 }))
    case .action, .partReference, .enumerationCase, .statements:
      return nil
    }
  }

  func otherThingsRequiredByDeclaration(of thing: Thing) -> [UnicodeText] {
    var result: [UnicodeText] = []
    for enumerationCase in thing.cases {
      if let contents = enumerationCase.contents,
         let contentThing = lookupThing(contents.key) {
        result.append(contentThing.globallyUniqueIdentifier(referenceLookup: [self]))
      }
    }
    return result
  }
  func allThings(sorted: Bool = false) -> [Thing] {
    let unsorted =
    things.values
      .lazy.map({ $0.values })
      .joined()
    if !sorted {
      return Array(unsorted)
    } else {
      var dictionary: [StrictString: Thing] = [:]
      for entry in unsorted {
        dictionary[StrictString(entry.globallyUniqueIdentifier(referenceLookup: [self]))] = entry
      }
      var alphabetical = dictionary.keys.sorted().map({ dictionary[$0]! })
      var sorted: [Thing] = []
      var already: Set<StrictString> = []
      var foundMore: Bool = false
      repeat {
        foundMore = false
        var index = 0
        while index != alphabetical.endIndex {
          let thing = alphabetical[index]
          if otherThingsRequiredByDeclaration(of: thing)
            .allSatisfy({ already.contains(StrictString($0)) }) {
            _ = alphabetical.remove(at: index)
            foundMore = true
            sorted.append(thing)
            already.insert(StrictString(thing.globallyUniqueIdentifier(referenceLookup: [self])))
          } else {
            index += 1
          }
        }
      } while !alphabetical.isEmpty && foundMore
      return sorted
    }
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupThing(_ identifier: UnicodeText, components: [TypeReference]) -> Thing? {
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
      if identifierMapping[name] != nil,
        identifierMapping[name].map({ StrictString($0) }) != StrictString(identifier) {
        errors.append(RedeclaredIdentifierError(identifier: UnicodeText(name), triggeringDeclaration: .action(action.declaration as! ParsedActionDeclaration), conflictingDeclarations: [lookupDeclaration(UnicodeText(name), signature: action.signature(orderedFor: UnicodeText(name)), specifiedReturnValue: action.returnValue, parentContexts: [])!]))
      }
      identifierMapping[name] = identifier
    }
    actions[StrictString(identifier), default: [:]][action.signature(orderedFor: identifier).map({ $0.key }), default: [:]][action.returnValue?.key] = action
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
  func lookupActions(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??,
    parentContexts: [ReferenceDictionary]
  ) -> [ActionIntermediate] {
    guard let mappedIdentifier = identifierMapping[StrictString(identifier)],
      let group = actions[StrictString(mappedIdentifier)] else {
      return []
    }
    let mappedSignature = signature.map({ $0.key.resolving(fromReferenceLookup: parentContexts.appending(self)) })
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
        let mappedReturn = value.key.resolving(fromReferenceLookup: parentContexts.appending(self))
        if let result = set[mappedReturn] {
          return [result]
        }
      case .some(.none):
        if let result = set[.none] ?? set[.statements] {
          return [result]
        }
      case .none:
        if set.count == 1 {
          return Array(set.values)
        } else {
          return set.values.filter({ $0.isMemberWrapper })
        }
      }
    }
    return []
  }
  func lookupAction(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??,
    parentContexts: [ReferenceDictionary]
  ) -> ActionIntermediate? {
    let all = lookupActions(
      identifier,
      signature: signature,
      specifiedReturnValue: specifiedReturnValue,
      parentContexts: parentContexts
    )
    if all.count == 1 {
      return all[0]
    } else {
      return nil
    }
  }

  func allActions(sorted: Bool = false) -> [ActionIntermediate] {
    let result =
    actions.values
      .lazy.map({ $0.values })
      .joined()
      .lazy.map({ $0.values })
      .joined()
    if !sorted {
      return Array(result)
    } else {
      var dictionary: [StrictString: ActionIntermediate] = [:]
      for entry in result {
        dictionary[StrictString(entry.globallyUniqueIdentifier(referenceLookup: [self]))] = entry
      }
      return dictionary.keys.sorted().map({ dictionary[$0]! })
    }
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupActions(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??,
    externalLookup: [ReferenceDictionary] = []
  ) -> [ActionIntermediate] {
    for index in indices.reversed() {
      let scope = self[index]
      let found = scope.lookupActions(
        identifier,
        signature: signature,
        specifiedReturnValue: specifiedReturnValue,
        parentContexts: externalLookup.appending(contentsOf: self[..<index])
      )
      if !found.isEmpty {
        return found
      }
    }
    return []
  }
  func lookupAction(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??,
    externalLookup: [ReferenceDictionary] = []
  ) -> ActionIntermediate? {
    for index in indices.reversed() {
      let scope = self[index]
      if let found = scope.lookupAction(
        identifier,
        signature: signature,
        specifiedReturnValue: specifiedReturnValue,
        parentContexts: externalLookup.appending(contentsOf: self[..<index])
      ) {
        return found
      }
    }
    return nil
  }
}

extension ReferenceDictionary {
  func lookupCreation(
    of thing: TypeReference
  ) -> ActionIntermediate? {
    for (_, signatureGroup) in actions {
      for (_, returnGroup) in signatureGroup {
        for (returnValue, action) in returnGroup {
          if returnValue == thing,
            action.implementation == nil {
            return action
          }
        }
      }
    }
    return nil
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupCreation(
    of thing: Thing
  ) -> ActionIntermediate? {
    let reference = thing.reference(resolvingFromReferenceLookup: self)
    for index in indices.reversed() {
      let scope = self[index]
      if let found = scope.lookupCreation(
        of: reference
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
      if identifierMapping[name] != nil {
        errors.append(RedeclaredIdentifierError(identifier: UnicodeText(name), triggeringDeclaration: .ability(ability.declaration), conflictingDeclarations: [lookupDeclaration(UnicodeText(name), signature: ability.parameters.ordered(for: UnicodeText(name)).map({ _ in nil }), specifiedReturnValue: nil, parentContexts: [])!]))
      }
      identifierMapping[name] = identifier
    }
    abilities[StrictString(identifier)] = ability
    return errors
  }

  func lookupAbility(identifier: UnicodeText) -> Ability? {
    return abilities[StrictString(resolve(identifier: identifier))]
  }
  mutating func modifyAbility(identifier: UnicodeText, transformation: (inout Ability) -> Void) {
    let realIdentifier = identifierMapping[StrictString(identifier)] ?? identifier
    transformation(&abilities[StrictString(realIdentifier)]!)
  }

  func allAbilities() -> [Ability] {
    return Array(abilities.values)
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupAbility(identifier: UnicodeText) -> Ability? {
    for scope in reversed() {
      if let found = scope.lookupAbility(identifier: identifier) {
        return found
      }
    }
    return nil
  }
}

extension ReferenceDictionary {
  mutating func resolveTypeIdentifiers(externalLookup: [ReferenceDictionary]) {
    var newThings: [StrictString: [[TypeReference]: Thing]] = [:]
    for (thingName, group) in things {
      for (signature, thing) in group {
        let resolvedSignature = signature.map({ $0.resolving(fromReferenceLookup: externalLookup.appending(self)) })
        newThings[thingName, default: [:]][resolvedSignature] = thing
      }
    }
    things = newThings

    var newActions: [StrictString: [[TypeReference]: [TypeReference?: ActionIntermediate]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        let resolvedSignature = signature.map({ $0.resolving(fromReferenceLookup: externalLookup.appending(self)) })
        for (overload, action) in returnOverloads {
          let resolvedReturn = overload.flatMap({ $0.resolving(fromReferenceLookup: externalLookup.appending(self)) })
          newActions[actionName, default: [:]][resolvedSignature, default: [:]][resolvedReturn] = action
        }
      }
    }
    actions = newActions
  }

  mutating func resolveTypes(parentContexts: [ReferenceDictionary]) {
    var newActions: [StrictString: [[TypeReference]: [TypeReference?: ActionIntermediate]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        for (overload, action) in returnOverloads {
          var modified = action
          modified.implementation?.resolveTypes(
            context: action,
            referenceLookup: parentContexts.appending(self),
            finalReturnValue: action.returnValue
          )
          newActions[actionName, default: [:]][signature, default: [:]][overload] = modified
        }
      }
    }
    actions = newActions
  }

  func validateReferencesAsModule(
    moduleWideImports: [ModuleIntermediate],
    errors: inout [ReferenceError]
  ) {
    let referenceLookup = moduleWideImports.map({ $0.referenceDictionary }).appending(self)
    for thing in allThings() {
      thing.documentation?.validateReferences(referenceLookup: referenceLookup, errors: &errors)
    }
    for action in allActions() {
      action.validateReferences(referenceLookup: referenceLookup, errors: &errors)
    }
    for ability in allAbilities() {
      ability.documentation?.validateReferences(referenceLookup: referenceLookup, errors: &errors)
    }
  }
}

extension ReferenceDictionary {

  func applyingTestCoverageTracking(externalLookup: [ReferenceDictionary]) -> ReferenceDictionary {
    var new = self
    for action in allActions() {
      if let wrapped = action.wrappedToTrackCoverage(referenceLookup: [self]) {
        _ = new.add(action: wrapped)
      }
    }
    new.resolveTypeIdentifiers(externalLookup: externalLookup)
    return new
  }
}

extension ReferenceDictionary {
  mutating func removeUnreachable(
    fromEntryPoints entryPoints: inout Set<StrictString>,
    externalReferenceLookup: [ReferenceDictionary]
  ) {
    let referenceLookup = externalReferenceLookup.appending(self)
    var optimized = ReferenceDictionary()
    optimized.languages = self.languages // For temporary simplicity; not output anyway.
    var found: Set<StrictString> = []
    var stillRequired: Set<StrictString> = entryPoints
    var foundSomething = false
    repeat {
      foundSomething = false
      for thing in allThings() {
        if let swift = thing.swiftName.map({ StrictString($0) }),
           stillRequired.contains(swift) {
          stillRequired.remove(swift)
          foundSomething = true
          found.insert(StrictString(thing.globallyUniqueIdentifier(referenceLookup: referenceLookup)))
          _ = optimized.add(thing: thing)
          for child in thing.requiredIdentifiers(moduleAndExternalReferenceLookup: referenceLookup).lazy.map({ StrictString($0) }) {
            if !found.contains(child) {
              stillRequired.insert(child)
            }
          }
        }
        let identifier = StrictString(thing.globallyUniqueIdentifier(referenceLookup: referenceLookup))
        if stillRequired.contains(identifier) {
          stillRequired.remove(identifier)
          foundSomething = true
          found.insert(identifier)
          _ = optimized.add(thing: thing)
          for child in thing.requiredIdentifiers(moduleAndExternalReferenceLookup: referenceLookup).lazy.map({ StrictString($0) }) {
            if !found.contains(child) {
              stillRequired.insert(child)
            }
          }
        }
      }
      for action in allActions() {
        if let swift = action.swiftSignature(referenceLookup: referenceLookup).map({ StrictString($0) }),
           stillRequired.contains(swift) {
          stillRequired.remove(swift)
          foundSomething = true
          found.insert(StrictString(action.globallyUniqueIdentifier(referenceLookup: referenceLookup)))
          _ = optimized.add(action: action)
          for identifer in action.requiredIdentifiers(
            moduleAndExternalReferenceLookup: referenceLookup
          ).lazy.map({ StrictString($0) }) {
            if !found.contains(identifer) {
              stillRequired.insert(identifer)
            }
          }
        }
        let identifier = StrictString(action.globallyUniqueIdentifier(referenceLookup: referenceLookup))
        if stillRequired.contains(identifier) {
          stillRequired.remove(identifier)
          foundSomething = true
          found.insert(identifier)
          _ = optimized.add(action: action)
          for child in action.requiredIdentifiers(moduleAndExternalReferenceLookup: referenceLookup).lazy.map({ StrictString($0) }) {
            if !found.contains(child) {
              stillRequired.insert(child)
            }
          }
        }
      }
    } while !stillRequired.isEmpty && foundSomething
    self = optimized
    entryPoints = stillRequired
  }
}
