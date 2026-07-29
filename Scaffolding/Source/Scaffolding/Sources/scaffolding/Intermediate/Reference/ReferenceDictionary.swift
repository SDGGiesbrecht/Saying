import Saying
import Syntax

struct ReferenceDictionary {
  internal let scope: ScopeType
  private var languages: Set<UnicodeText>
  private var identifierMapping: [UnicodeText: MappedIdentifier]
  private var things: [UnicodeText: [[TypeReference]: Thing]]
  private var actions: [UnicodeText: [[TypeReference]: [TypeReference?: CopyReducing<ActionIntermediate>]]]
  private var abilities: [UnicodeText: Ability]
}

extension ReferenceDictionary {
  init(scope: ScopeType) {
    self.init(
      scope: scope,
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
    languages.insert(language)
  }

  func languageIsKnown(_ language: UnicodeText) -> Bool {
    return self.languages.contains(language)
  }
}

extension ReferenceDictionary {
  func resolveIfKnown(identifier: UnicodeText) -> UnicodeText? {
    return identifierMapping[identifier]?.identifier
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
      let action = lookupAction(
        identifier,
        signature: fullSignature,
        specifiedReturnValue: specifiedReturnValue,
        parentContexts: parentContexts,
        reportAllForErrorAnalysis: false
      )?.declaration as? ParsedActionDeclaration {
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
      if identifierMapping[name] != nil,
        identifierMapping[name]?.identifier != identifier {
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: thing.declaration.genericDeclaration, conflictingDeclarations: [lookupDeclaration(name, signature: [], specifiedReturnValue: nil, parentContexts: [])!]))
      }
      identifierMapping[name] = MappedIdentifier(identifier: identifier, reordering: thing.parameters.reordering(from: name, to: identifier))
    }
    let parameters: [TypeReference] = thing.parameters.ordered(for: identifier)
      .map({ $0.resolvedType!.key })
    things[identifier, default: [:]][parameters] = thing
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
      if let action = enumerationCase.unwrapOtherwiseAction {
        errors.append(contentsOf: add(action: action))
      }
      errors.append(contentsOf: add(action: enumerationCase.checkAction))
    }
    return errors
  }

  func lookupThing(_ identifier: UnicodeText, components: [TypeReference]) -> Thing? {
    guard let mappedIdentifier = identifierMapping[identifier],
      let group = things[mappedIdentifier.identifier] else {
      return nil
    }
    let mappedComponents = order(
      components.map({ $0.resolving(fromReferenceLookup: [self]) }),
      for: mappedIdentifier.reordering
    )
    return group[mappedComponents]
  }
  func lookupThing(_ reference: TypeReference) -> Thing? {
    switch reference {
    case .simple(let simple):
      return lookupThing(simple, components: [])
    case .compound(identifier: let identifier, components: let components):
      return lookupThing(identifier, components: components.map({ $0 }))
    case .action, .partReference, .enumerationCase, .statements:
      return nil
    }
  }

  func otherThingsRequiredByDeclaration(of thing: Thing) -> [UnicodeText] {
    var requirements: [ParsedTypeReference] = []
    for parameter in thing.parameters.inAnyOrder {
      requirements.append(parameter.resolvedType!)
    }
    for enumerationCase in thing.cases {
      if let contents = enumerationCase.contents {
        requirements.append(contents)
      }
    }
    for part in thing.parts {
      requirements.append(part.contents)
    }
    return requirements.compactMap { requirement in
      return lookupThing(requirement.key)?.globallyUniqueIdentifier(referenceLookup: [self])
    }
  }
  func allThings(sorted: Bool = false) -> [Thing] {
    let unsorted =
    things.values
      .lazy.map({ $0.values })
      .joined()
    if !sorted {
      return Array(unsorted)
    } else {
      var dictionary: [UnicodeText: Thing] = [:]
      for entry in unsorted {
        dictionary[entry.globallyUniqueIdentifier(referenceLookup: [self])] = entry
      }
      var alphabetical = dictionary.keys.sorted(by: { $0.lexicographicallyPrecedes($1) }).map({ dictionary[$0]! })
      var sorted: [Thing] = []
      var already: Set<UnicodeText> = []
      var foundMore: Bool = false
      repeat {
        foundMore = false
        var index = 0
        while index != alphabetical.endIndex {
          let thing = alphabetical[index]
          if otherThingsRequiredByDeclaration(of: thing)
            .allSatisfy({ already.contains($0) }) {
            _ = alphabetical.remove(at: index)
            foundMore = true
            sorted.append(thing)
            already.insert(thing.globallyUniqueIdentifier(referenceLookup: [self]))
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
  func lookupThing(_ reference: TypeReference) -> Thing? {
    for scope in reversed() {
      if let found = scope.lookupThing(reference) {
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
        identifierMapping[name]?.identifier != identifier {
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: .action(action.declaration as! ParsedActionDeclaration), conflictingDeclarations: [lookupDeclaration(name, signature: action.signature(orderedFor: name), specifiedReturnValue: action.returnValue, parentContexts: [])!]))
      }
      identifierMapping[name] = MappedIdentifier(identifier: identifier, reordering: action.parameters.reordering(from: name, to: identifier))
    }
    actions[identifier, default: [:]][action.signature(orderedFor: identifier).map({ $0.key }), default: [:]][action.returnValue?.key] = CopyReducing(action)
    return errors
  }

  private func referenceActions(
    from overloads: [[TypeReference] : [TypeReference?: CopyReducing<ActionIntermediate>]]
  ) -> [TypeReference?: CopyReducing<ActionIntermediate>] {
    var result: [TypeReference?: CopyReducing<ActionIntermediate>] = [:]
    for (signature, returnOverloads) in overloads {
      for (returnValue, action) in returnOverloads {
        let actionType = TypeReference.action(parameters: signature, returnValue: returnValue)
        result[actionType] = CopyReducing(action.value.asReference())
      }
    }
    return result
  }
  func lookupActions(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??,
    parentContexts: [ReferenceDictionary],
    reportAllForErrorAnalysis: Bool
  ) -> [ActionIntermediate] {
    guard let mappedIdentifier = identifierMapping[identifier],
      let group = actions[mappedIdentifier.identifier] else {
      return []
    }
    let mappedSignature = signature.isEmpty ? [] : order(
      signature.map({ $0.key.resolving(fromReferenceLookup: parentContexts + [self]) }),
      for: mappedIdentifier.reordering
    )
    let returnOverloads: [() -> [TypeReference?: CopyReducing<ActionIntermediate>]]
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
        let mappedReturn = value.key.resolving(fromReferenceLookup: parentContexts + [self])
        if let result = set[mappedReturn] {
          return [result.value]
        }
      case .some(.none):
        if let result = set[.none] ?? set[.statements] {
          return [result.value]
        }
      case .none:
        if set.count == 1 {
          return set.values.map { $0.value }
        } else {
          if reportAllForErrorAnalysis {
            return set.values.map { $0.value }
          } else {
            return set.values.compactMap { copyReducing in
              let action = copyReducing.value
              return action.isMemberWrapper ? action : nil
            }
          }
        }
      }
    }
    return []
  }
  func lookupAction(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??,
    parentContexts: [ReferenceDictionary],
    reportAllForErrorAnalysis: Bool
  ) -> ActionIntermediate? {
    let all = lookupActions(
      identifier,
      signature: signature,
      specifiedReturnValue: specifiedReturnValue,
      parentContexts: parentContexts,
      reportAllForErrorAnalysis: reportAllForErrorAnalysis
    )
    if all.count == 1 {
      return all[0]
    } else {
      return nil
    }
  }

  func allActions(
    filter: (CopyReducing<ActionIntermediate>) -> Bool = { _ in true },
    sorted: Bool = false
  ) -> [CopyReducing<ActionIntermediate>] {
    let result =
    actions.values
      .lazy.map({ $0.values })
      .joined()
      .lazy.map({ $0.values })
      .joined()
      .lazy.filter(filter)
    if !sorted {
      return Array(result)
    } else {
      var dictionary: [UnicodeText: CopyReducing<ActionIntermediate>] = [:]
      for entry in result {
        dictionary[entry.value.globallyUniqueIdentifier(referenceLookup: [self])] = entry
      }
      return dictionary.keys.sorted(by: { $0.lexicographicallyPrecedes($1) }).map({ dictionary[$0]! })
    }
  }
}
extension Array where Element == ReferenceDictionary {
  func lookupActions(
    _ identifier: UnicodeText,
    signature: [ParsedTypeReference],
    specifiedReturnValue: ParsedTypeReference??,
    externalLookup: [ReferenceDictionary] = [],
    reportAllForErrorAnalysis: Bool
  ) -> [ActionIntermediate] {
    return indices.reversed().flatMap { index in
      let scope = self[index]
      return scope.lookupActions(
        identifier,
        signature: signature,
        specifiedReturnValue: specifiedReturnValue,
        parentContexts: externalLookup + self[..<index],
        reportAllForErrorAnalysis: reportAllForErrorAnalysis
      )
    }
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
        parentContexts: externalLookup + self[..<index],
        reportAllForErrorAnalysis: false
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
          if returnValue == thing {
            let actionValue = action.value
            if actionValue.isCreation {
              return actionValue
            }
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
        errors.append(RedeclaredIdentifierError(identifier: name, triggeringDeclaration: .ability(ability.declaration), conflictingDeclarations: [lookupDeclaration(name, signature: ability.parameters.ordered(for: name).map({ _ in nil }), specifiedReturnValue: nil, parentContexts: [])!]))
      }
      identifierMapping[name] = MappedIdentifier(identifier: identifier, reordering: ability.parameters.reordering(from: name, to: identifier))
    }
    abilities[identifier] = ability
    return errors
  }

  func lookupAbility(identifier: UnicodeText) -> Ability? {
    return abilities[resolve(identifier: identifier)]
  }
  mutating func modifyAbility(identifier: UnicodeText, transformation: (inout Ability) -> Void) {
    let realIdentifier = identifierMapping[identifier]?.identifier ?? identifier
    transformation(&abilities[realIdentifier]!)
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
    var newThings: [UnicodeText: [[TypeReference]: Thing]] = [:]
    for (thingName, group) in things {
      for (signature, thing) in group {
        let resolvedSignature = signature.map({ $0.resolving(fromReferenceLookup: externalLookup + [self]) })
        newThings[thingName, default: [:]][resolvedSignature] = thing
      }
    }
    things = newThings

    var newActions: [UnicodeText: [[TypeReference]: [TypeReference?: CopyReducing<ActionIntermediate>]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        let resolvedSignature = signature.map({ $0.resolving(fromReferenceLookup: externalLookup + [self]) })
        for (overload, action) in returnOverloads {
          let resolvedReturn = overload.flatMap({ $0.resolving(fromReferenceLookup: externalLookup + [self]) })
          newActions[actionName, default: [:]][resolvedSignature, default: [:]][resolvedReturn] = action
        }
      }
    }
    actions = newActions
  }

  mutating func resolveSpecializedAccess(externalLookup: [ReferenceDictionary]) {
    while performOnePassResolvingSpecializedAccess(externalLookup: externalLookup) {}
  }
  mutating func performOnePassResolvingSpecializedAccess(externalLookup: [ReferenceDictionary]) -> Bool {
    let allLookup = externalLookup + [self]
    var changedSomething = false
    for (thingName, group) in things {
      for (signature, thing) in group {
        let parameters = thing.parameters.inAnyOrder
        if !parameters.isEmpty {
          let parameterAccess: [(access: AccessIntermediate, testOnly: Bool)] = parameters.lazy.compactMap { parameter in
            guard let type = parameter.resolvedType else {
              return nil
            }
            return (access: type.derivedAccessLimit(referenceLookup: allLookup), testOnly: type.derivedTestAccess(referenceLookup: allLookup))
          }
          let access = min(thing.access, parameterAccess.lazy.map({ $0.access }).min() ?? .clients)
          if access != thing.access {
            things[thingName]![signature]!.resolveSpecializedAccess(to: access)
            changedSomething = true
          }
          let testOnly = thing.testOnlyAccess || parameterAccess.contains(where: { $0.testOnly })
          if testOnly != thing.testOnlyAccess {
            things[thingName]![signature]!.testOnlyAccess = testOnly
            changedSomething = true
          }
        }
      }
    }
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        for (overload, copyReducing) in returnOverloads {
          let action = copyReducing.value
          if action.isSpecialized {
            let proxy = ParsedTypeReference.action(parameters: action.parameters.inAnyOrder.map({ $0.type }), returnValue: action.returnValue)
            let access = min(action.access, proxy.derivedAccessLimit(referenceLookup: allLookup))
            if access != action.access {
              actions[actionName]![signature]![overload]!.value.resolveSpecializedAccess(to: access)
              changedSomething = true
            }
            let testOnly = action.testOnlyAccess || proxy.derivedTestAccess(referenceLookup: allLookup)
            if testOnly != action.testOnlyAccess {
              actions[actionName]![signature]![overload]!.value.testOnlyAccess = testOnly
              changedSomething = true
            }
          }
        }
      }
    }
    return changedSomething
  }

  mutating func resolveTypes(parentContexts: [ReferenceDictionary]) {
    var newActions: [UnicodeText: [[TypeReference]: [TypeReference?: CopyReducing<ActionIntermediate>]]] = [:]
    for (actionName, group) in actions {
      for (signature, returnOverloads) in group {
        for (overload, copyReducing) in returnOverloads {
          let action = copyReducing.value
          var modified = action
          modified.implementation?.resolveTypes(
            context: action,
            referenceLookup: parentContexts + [self],
            finalReturnValue: action.returnValue
          )
          newActions[actionName, default: [:]][signature, default: [:]][overload] = CopyReducing(modified)
        }
      }
    }
    actions = newActions
  }

  func validateReferencesAsModule(
    moduleWideImports: [ModuleIntermediate],
    errors: inout [ReferenceError]
  ) {
    let referenceLookup = moduleWideImports.map({ $0.referenceDictionary }) + [self]
    for thing in allThings() {
      thing.validateReferences(referenceLookup: referenceLookup, errors: &errors)
    }
    for action in allActions() {
      action.value.validateReferences(referenceLookup: referenceLookup, errors: &errors)
    }
    for ability in allAbilities() {
      ability.documentation?.validateReferences(
        inheritedVisibility: ability.access,
        referenceLookup: referenceLookup,
        errors: &errors
      )
    }
  }
}

extension ReferenceDictionary {
  mutating func resolveNestedReferenceCounting(externalLookup: [ReferenceDictionary]) {
    while performOnePassResolvingNestedReferenceCounting(externalLookup: externalLookup) {}
  }
  private mutating func performOnePassResolvingNestedReferenceCounting(
    externalLookup: [ReferenceDictionary]
  ) -> Bool {
    let allLookup = externalLookup + [self]
    var changedSomething = false
    for (thingName, group) in things {
      thingIteration: for (signature, thing) in group {
        if thing.requiresCleanUp != nil {
          continue thingIteration
        } else {
          var required = false
          if let native = thing.c {
            required = native.release != nil
          } else {
            partIteration: for component in [
              thing.parts.map({ $0.contents }),
              thing.cases.compactMap({ $0.contents })
            ].joined() {
              if let type = allLookup.lookupThing(component.key) {
                if let known = type.requiresCleanUp {
                  if known {
                    required = true
                    break partIteration
                  } else {
                    continue partIteration
                  }
                } else {
                  continue thingIteration
                }
              }
            }
          }
          things[thingName]![signature]?.requiresCleanUp = required
          changedSomething = true
        }
      }
    }
    return changedSomething
  }
}

extension ReferenceDictionary {

  func applyingTestCoverageTracking(externalLookup: [ReferenceDictionary]) -> ReferenceDictionary {
    var new = self
    for action in allActions() {
      let wrapped = action.value.wrappedToTrackCoverage(referenceLookup: externalLookup + [self])
      _ = new.add(action: wrapped)
    }
    new.resolveTypeIdentifiers(externalLookup: externalLookup)
    return new
  }
}

extension ReferenceDictionary {
  mutating func removeUnreachable(
    fromEntryPoints entryPoints: inout Set<UnicodeText>,
    externalReferenceLookup: [ReferenceDictionary]
  ) {
    let referenceLookup = externalReferenceLookup + [self]
    var optimized = ReferenceDictionary(scope: self.scope)
    optimized.languages = self.languages // For temporary simplicity; not output anyway.
    var found: Set<UnicodeText> = []
    var stillRequired: Set<UnicodeText> = entryPoints
    var foundSomething = false
    repeat {
      foundSomething = false
      for thing in allThings() {
        if let swift = thing.swiftName,
           stillRequired.contains(swift) {
          stillRequired.remove(swift)
          foundSomething = true
          found.insert(swift)
          found.insert(thing.globallyUniqueIdentifier(referenceLookup: referenceLookup))
          _ = optimized.add(thing: thing)
          for child in thing.requiredIdentifiers(
            moduleAndExternalReferenceLookup: referenceLookup,
            platform: Swift.self
          ) {
            if !found.contains(child) {
              stillRequired.insert(child)
            }
          }
        }
        let identifier = thing.globallyUniqueIdentifier(referenceLookup: referenceLookup)
        if stillRequired.contains(identifier) {
          stillRequired.remove(identifier)
          foundSomething = true
          found.insert(identifier)
          _ = optimized.add(thing: thing)
          for child in thing.requiredIdentifiers(
            moduleAndExternalReferenceLookup: referenceLookup,
            platform: Swift.self
          ) {
            if !found.contains(child) {
              stillRequired.insert(child)
            }
          }
        }
      }
      for copyReducing in allActions() {
        let action = copyReducing.value
        if let swift = action.swiftSignature(referenceLookup: referenceLookup),
           stillRequired.contains(swift) {
          stillRequired.remove(swift)
          foundSomething = true
          found.insert(swift)
          found.insert(action.globallyUniqueIdentifier(referenceLookup: referenceLookup))
          _ = optimized.add(action: action)
          for identifer in action.requiredIdentifiers(
            moduleAndExternalReferenceLookup: referenceLookup,
            platform: Swift.self
          ) {
            if !found.contains(identifer) {
              stillRequired.insert(identifer)
            }
          }
        }
        let identifier = action.globallyUniqueIdentifier(referenceLookup: referenceLookup)
        if stillRequired.contains(identifier) {
          stillRequired.remove(identifier)
          foundSomething = true
          found.insert(identifier)
          _ = optimized.add(action: action)
          for child in action.requiredIdentifiers(
            moduleAndExternalReferenceLookup: referenceLookup,
            platform: Swift.self
          ) {
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

extension ReferenceDictionary: CustomStringConvertible {

  var description: String {
    return String(describing: [
      scope,
      identifierMapping.keys.sorted(by: { $0.lexicographicallyPrecedes($1) })
    ])
  }
}
