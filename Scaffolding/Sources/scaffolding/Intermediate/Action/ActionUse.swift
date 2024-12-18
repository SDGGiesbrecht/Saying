import SDGLogic
import SDGText

struct ActionUse {
  var actionName: StrictString
  var arguments: [ActionUseArgument]
  var source: ParsedAction?
  var passage: ParameterPassage
  var explicitResultType: ParsedTypeReference?
  var resolvedResultType: ParsedTypeReference??
  var narrowedResultTypes: [ParsedTypeReference?]?
}

extension ActionUse {

  init(_ use: ParsedAction) {
    actionName = use.name()
    switch use {
    case .compound(let compound):
      arguments = compound.arguments.arguments.map { argument in
        switch argument {
        case .passed(let passed):
          return .action(ActionUse(passed.argument))
        case .flow(let flow):
          return .flow(StatementListIntermediate(flow.statements))
        }
      }
    case .reference:
      arguments = []
    case .simple:
      arguments = []
    }
    source = use
    passage = .into
  }

  init(_ use: ParsedAnnotatedAction) {
    self = ActionUse(use.action)
    let type = use.type.map({ ParsedTypeReference($0.type) })
    if use.type?.yieldArrow ≠ nil {
      explicitResultType = .action(parameters: [], returnValue: type)
    } else {
      explicitResultType = type
    }
    switch use.passage {
    case .none:
      passage = .into
    case .bullet:
      passage = .out
    case .throughArrow:
      passage = .through
    }
  }
}

extension ActionUse {
  func localActions() -> [ActionIntermediate] {
    if passage == .out {
      return [.parameterAction(names: [actionName], parameters: .none, returnValue: explicitResultType)]
    } else {
      return arguments.flatMap { $0.localActions() }
    }
  }
  func passedReferences() -> [ActionUse] {
    if passage == .through {
      return [self]
    } else {
      return arguments.flatMap { $0.passedReferences() }
    }
  }
}

extension ActionUse {
  enum ArgumentTypeResolutionResult {
    case resolved(ParsedTypeReference??)
    case narrowed([ParsedTypeReference?])
    case failed
  }
  mutating func resolveArgumentTypes(
    specifiedReturnValue: ParsedTypeReference??,
    referenceLookup: [ReferenceDictionary]
  ) -> ArgumentTypeResolutionResult {
    var guesses: [[ParsedTypeReference]] = [[]]
    for argument in arguments {
      switch argument.resolvedResultType {
      case .some(.some(let knownType)):
        for index in guesses.indices {
          guesses[index].append(knownType)
        }
      case .some(.none):
        return .failed
      case .none:
        guard let narrowed = argument.narrowedResultTypes?.mapAll({ $0 }) else {
          return .failed
        }
        guesses = guesses.flatMap({ preceding in
          return narrowed.map({ guess in
            return preceding.appending(guess)
          })
        })
      }
    }
    let actions = guesses.flatMap { guess in
      return referenceLookup.lookupActions(
        actionName,
        signature: guess,
        specifiedReturnValue: specifiedReturnValue
      ).map { action in
        return (guess, action)
      }
    }
    if actions.count == 1 {
      let (guess, action) = actions[0]
      for (guessEntry, index) in zip(guess, arguments.indices) {
        arguments[index].resolvedResultType = .some(guessEntry)
      }
      return .resolved(action.returnValue)
    } else if actions.count > 1 {
      return .narrowed(actions.map({ $0.1.returnValue }))
    }
    return .failed
  }
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary],
    specifiedReturnValue: ParsedTypeReference??,
    finalReturnValue: ParsedTypeReference?
  ) {
    for index in arguments.indices {
      let explicitArgumentReturnValue: ParsedTypeReference??
      switch arguments[index].explicitResultType {
      case .some(let specified):
        explicitArgumentReturnValue = .some(.some(specified))
      case .none:
        explicitArgumentReturnValue = .none
      }
      arguments[index].resolveTypes(
        context: context,
        referenceLookup: referenceLookup,
        specifiedReturnValue: explicitArgumentReturnValue,
        finalReturnValue: finalReturnValue
      )
    }
    switch specifiedReturnValue {
    case .some(.some(let value)):
      resolvedResultType = value
      if arguments.contains(where: { $0.resolvedResultType == nil }) {
        _ = resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookup
        )
      }
    case .some(.none):
      resolvedResultType = .some(.none)
      if arguments.contains(where: { $0.resolvedResultType == nil }) {
        _ = resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookup
        )
      }
    case .none:
      if let parameter = context?.lookupParameter(actionName) {
        resolvedResultType = parameter.type
        if arguments.contains(where: { $0.resolvedResultType == nil }) {
          _ = resolveArgumentTypes(
            specifiedReturnValue: specifiedReturnValue,
            referenceLookup: referenceLookup
          )
        }
      } else {
        switch resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookup
        ) {
        case .resolved(let resolved):
          resolvedResultType = resolved
        case .narrowed(let narrowed):
          narrowedResultTypes = narrowed
        case .failed:
          return
        }
      }
    }
  }

  func validateReferences(
    context: [ReferenceDictionary],
    testContext: Bool,
    errors: inout [ReferenceError]
  ) {
    var local = ReferenceDictionary()
    for argument in arguments {
      argument.validateReferences(
        context: context.appending(local),
        testContext: testContext,
        errors: &errors
      )
      let newActions = argument.localActions()
      for new in newActions {
        errors.append(contentsOf: local.add(action: new).map({ .redeclaredLocalIdentifier(error: $0) }))
      }
      if !newActions.isEmpty {
        local.resolveTypeIdentifiers(externalLookup: context)
      }
    }
    if passage != .out {
      if let signature = arguments.mapAll({ $0.resolvedResultType })?.mapAll({ $0 }),
         let action = context.lookupAction(
          actionName,
          signature: signature,
          specifiedReturnValue: resolvedResultType) {
        if ¬testContext,
           action.testOnlyAccess {
          errors.append(.actionUnavailableOutsideTests(reference: source!))
        }
      } else {
        errors.append(.noSuchAction(name: actionName, reference: source!))
      }
    }
  }
}

extension ActionUse {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> ActionUse {
    return ActionUse(
      actionName: actionName,
      arguments: arguments.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
      source: source,
      passage: passage,
      explicitResultType: explicitResultType
        .flatMap({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> ActionUse {
    return ActionUse(
      actionName: actionName,
      arguments: arguments.map({ $0.specializing(typeLookup: typeLookup) }),
      source: source,
      passage: passage,
      explicitResultType: explicitResultType.flatMap({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}

extension ActionUse {
  static func isReferenceNotCall<T>(name: StrictString, arguments: [T]) -> Bool? {
    if arguments.isEmpty {
      if name.contains("(") {
        return true
      } else {
        return nil
      }
    } else {
      return false
    }
  }
}

extension ActionUse {
  func countCoverageSubregions(count: inout Int) {
    for argument in arguments {
      argument.countCoverageSubregions(count: &count)
    }
  }
}

extension ActionUse {

  func requiredIdentifiers(
    context: [ReferenceDictionary]
  ) -> [StrictString] {
    var result: [StrictString] = []
    for argument in arguments {
      result.append(
        contentsOf: argument.requiredIdentifiers(
          context: context
        )
      )
    }
    if passage != .out {
      if let signature = arguments.mapAll({ $0.resolvedResultType })?.mapAll({ $0 }),
         let action = context.lookupAction(
          actionName,
          signature: signature,
          specifiedReturnValue: resolvedResultType) {
        result.append(action.globallyUniqueIdentifier(referenceLookup: context))
      }
    }
    return result
  }
}
