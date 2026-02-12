struct ActionUse {
  var actionName: UnicodeText
  var arguments: [ActionUseArgument]
  var literal: LiteralIntermediate?
  var source: ParsedAction?
  var passage: ParameterPassage
  var explicitResultType: ParsedTypeReference?
  var resolvedResultType: ParsedTypeReference??
  var narrowedResultTypes: [ParsedTypeReference?]?
}

extension ActionUse {

  static func construct(_ use: ParsedAction) -> Result<ActionUse, ErrorList<LiteralIntermediate.ConstructionError>> {
    var errors: [LiteralIntermediate.ConstructionError] = []
    let arguments: [ActionUseArgument]
    let literal: LiteralIntermediate?
    switch use {
    case .compound(let compound):
      arguments = compound.arguments.arguments.compactMap { argument in
        switch argument {
        case .passed(let passed):
          switch ActionUse.construct(passed.argument) {
          case .failure(let error):
            errors.append(contentsOf: error.errors)
            return nil
          case .success(let action):
            return .action(action)
          }
        case .flow(let flow):
          switch StatementListIntermediate.construct(flow) {
          case .failure(let error):
            errors.append(contentsOf: error.errors)
            return nil
          case .success(let statements):
            return .flow(statements)
          }
        }
      }
      literal = nil
    case .reference:
      arguments = []
      literal = nil
    case .simple:
      arguments = []
      literal = nil
    case .literal(let literalSyntax):
      arguments = []
      switch LiteralIntermediate.construct(literal: literalSyntax) {
      case .failure(let error):
        errors.append(contentsOf: error.errors)
        literal = nil
      case .success(let constructed):
        literal = constructed
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionUse(
        actionName: use.name(),
        arguments: arguments,
        literal: literal,
        source: use,
        passage: .into
      )
    )
  }

  static func construct(_ use: ParsedAnnotatedAction) -> Result<ActionUse, ErrorList<LiteralIntermediate.ConstructionError>> {
    return ActionUse.construct(use.action).map { action in
      var annotated = action
      let type = use.type.map({ ParsedTypeReference($0.type) })
      if use.type?.yieldArrow != nil {
        annotated.explicitResultType = .action(parameters: [], returnValue: type)
      } else {
        annotated.explicitResultType = type
      }
      switch use.passage {
      case .none:
        annotated.passage = .into
      case .bullet:
        annotated.passage = .out
      case .throughArrow:
        annotated.passage = .through
      }
      return annotated
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
  func passedReferences(
    platform: Platform.Type,
    referenceLookup: [ReferenceDictionary],
    skipLayer: Bool
  ) -> [ActionUse] {
    if passage == .through {
      if skipLayer {
        return []
      } else {
        return [self]
      }
    } else {
      var skipNextLayer = false
      if let signature = arguments.mapAll({ $0.resolvedResultType })?.mapAll({ $0 }),
        let action = referenceLookup.lookupAction(
          actionName,
          signature: signature,
          specifiedReturnValue: resolvedResultType
        ),
        platform.nativeImplementation(of: action) != nil,
        action.isFlow {
        skipNextLayer = true
      }
      return arguments.flatMap { argument in
        return argument.passedReferences(
          platform: platform,
          referenceLookup: referenceLookup,
          skipLayer: skipNextLayer
        )
      }
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
        specifiedReturnValue: specifiedReturnValue,
        reportAllForErrorAnalysis: false
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
    if literal != nil {
      return .resolved(
        .some(.some(.compilerGeneratedReference(to: LiteralIntermediate.unicodeTextName)))
      )
    }
    return .failed
  }
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary],
    specifiedReturnValue: ParsedTypeReference??,
    finalReturnValue: ParsedTypeReference?
  ) {
    var local = ReferenceDictionary()
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
        referenceLookup: referenceLookup.appending(local),
        specifiedReturnValue: explicitArgumentReturnValue,
        finalReturnValue: finalReturnValue
      )
      let newActions = arguments[index].localActions()
      for new in newActions {
        _ = local.add(action: new)
      }
      if !newActions.isEmpty {
        local.resolveTypeIdentifiers(externalLookup: referenceLookup)
      }
    }
    let referenceLookupWithFlowLocals = referenceLookup.appending(local)
    switch specifiedReturnValue {
    case .some(.some(let value)):
      resolvedResultType = value
      if arguments.contains(where: { $0.resolvedResultType == nil }) {
        _ = resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookupWithFlowLocals
        )
      }
    case .some(.none):
      resolvedResultType = .some(.none)
      if arguments.contains(where: { $0.resolvedResultType == nil }) {
        _ = resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookupWithFlowLocals
        )
      }
    case .none:
      if let parameter = context?.lookupParameter(actionName) {
        resolvedResultType = parameter.type
        if arguments.contains(where: { $0.resolvedResultType == nil }) {
          _ = resolveArgumentTypes(
            specifiedReturnValue: specifiedReturnValue,
            referenceLookup: referenceLookupWithFlowLocals
          )
        }
      } else {
        switch resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookupWithFlowLocals
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
    testContext: TestContext?,
    allowTestOnly: Bool,
    errors: inout [ReferenceError]
  ) {
    var local = ReferenceDictionary()
    for argument in arguments {
      argument.validateReferences(
        context: context.appending(local),
        testContext: testContext,
        allowTestOnly: allowTestOnly,
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
        testContext.validateAccess(
          to: action.access,
          testOnly: action.testOnlyAccess,
          allowTestOnly: allowTestOnly,
          errors: &errors,
          unavailableOutsideTestsError: { .actionUnavailableOutsideTests(reference: source!) },
          unavailableInVisibleTestsError: { .actionAccessNarrowerThanDocumentationVisibility(reference: source!) }
        )
        for (parameter, argument) in zip(action.parameters.ordered(for: actionName), arguments) {
          if parameter.passage != argument.passage {
            errors.append(.mismatchedPassage(attempted: argument.passage, expected: parameter.passage, location: argument.source!))
          }
        }
      } else {
        if let literal = literal,
           let resolved = resolvedResultType,
           let reference = resolved,
           let type = context.lookupThing(reference.key) {
          literal.validate(
            as: type,
            reference: reference,
            errors: &errors
          )
        } else {
          errors.append(.noSuchAction(name: actionName, reference: source!))
        }
      }
    }
  }
}

extension ActionUse {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> ActionUse {
    return ActionUse(
      actionName: actionName,
      arguments: arguments.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
      literal: literal,
      source: source,
      passage: passage,
      explicitResultType: explicitResultType
        .flatMap({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
      resolvedResultType: resolvedResultType
        .flatMap({ $0?.resolvingExtensionContext(typeLookup: typeLookup) }),
      narrowedResultTypes: narrowedResultTypes?
        .map({ $0?.resolvingExtensionContext(typeLookup: typeLookup) })
    )
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> ActionUse {
    return ActionUse(
      actionName: actionName,
      arguments: arguments.map({ $0.specializing(typeLookup: typeLookup) }),
      literal: literal,
      source: source,
      passage: passage,
      explicitResultType: explicitResultType.flatMap({ $0.specializing(typeLookup: typeLookup) }),
      resolvedResultType: resolvedResultType.flatMap({ $0?.specializing(typeLookup: typeLookup) }),
      narrowedResultTypes: narrowedResultTypes?.map({ $0?.specializing(typeLookup: typeLookup) })
    )
  }
}

extension ActionUse {
  static func isReferenceNotCall<T>(name: UnicodeText, arguments: [T]) -> Bool? {
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
  func coverageSubregions(counter: inout Int) -> [Int] {
    return arguments.flatMap { $0.coverageSubregions(counter: &counter) }
  }
}

extension ActionUse {

  func requiredIdentifiers(
    context: [ReferenceDictionary]
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
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
    if let literal = self.literal,
       let returnType = resolvedResultType,
       let reference = returnType,
       let thing = context.lookupThing(reference.key) {
      result.append(contentsOf: literal.requiredIdentifiers(type: thing, context: context))
      if let loading = literal.loadingAction(type: thing) {
        result.append(contentsOf: loading.requiredIdentifiers(context: context))
      }
    }
    return result
  }
}
