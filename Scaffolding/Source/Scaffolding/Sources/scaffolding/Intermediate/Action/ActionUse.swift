import Saying

struct ActionUse {
  var actionName: UnicodeText
  var arguments: [ActionUseArgument]
  var literal: LiteralIntermediate?
  var isList: Bool
  var actionLiteral: ActionLiteralIntermediate?
  var source: ParsedAction?
  var passage: ParameterPassage
  var explicitResultType: ParsedTypeReference?
  var resolvedResultType: ParsedTypeReference??
  var resolvedEntryType: ParsedTypeReference?
  var rearrangedParameters: [UnicodeText] = []
  var narrowedResultTypes: [ParsedTypeReference?]?
}

extension ActionUse {

  static func construct(_ use: ParsedAction) -> Result<ActionUse, ErrorList<LiteralIntermediate.ConstructionError>> {
    var errors: [LiteralIntermediate.ConstructionError] = []
    let arguments: [ActionUseArgument]
    let literal: LiteralIntermediate?
    let isList: Bool
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
      isList = false
    case .reference:
      arguments = []
      literal = nil
      isList = false
    case .simple:
      arguments = []
      literal = nil
      isList = false
    case .literal(let literalSyntax):
      arguments = []
      switch LiteralIntermediate.construct(literal: literalSyntax) {
      case .failure(let error):
        errors.append(contentsOf: error.errors)
        literal = nil
      case .success(let constructed):
        literal = constructed
      }
      isList = false
    case .list(let listSyntax):
      switch listSyntax {
      case .empty:
        arguments = []
      case .nonEmpty(let nonEmpty):
        arguments = nonEmpty.entries.entries.compactMap { argument in
          switch ActionUse.construct(argument) {
          case .failure(let error):
            errors.append(contentsOf: error.errors)
            return nil
          case .success(let action):
            return .action(action)
          }
        }
      }
      literal = nil
      isList = true
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionUse(
        actionName: use.name(),
        arguments: arguments,
        literal: literal,
        isList: isList,
        source: use,
        passage: .into
      )
    )
  }

  static func construct(_ use: ParsedAnnotatedArgument) -> Result<ActionUse, ErrorList<LiteralIntermediate.ConstructionError>> {
    switch construct(use.action) {
    case .failure(let errors):
      return .failure(errors)
    case .success(var action):
      switch use.passage {
      case .none:
        action.passage = .into
      case .bullet:
        action.passage = .out
      case .throughArrow:
        action.passage = .through
      }
      return .success(action)
    }
  }

  static func construct(_ use: ParsedAnnotatedAction) -> Result<ActionUse, ErrorList<LiteralIntermediate.ConstructionError>> {
    let passage: ParameterPassage = .into
    let type = use.type.map({ ParsedTypeReference($0.type) })
    var rearrangedParameters: [UnicodeText] = []
    let explicitResultType: ParsedTypeReference?
    if let actionPrefix = use.type?.actionPrefix {
      var parameters: [ParsedTypeReference] = []
      for parameter in actionPrefix.parameters?.parameters.parameters ?? [] {
        rearrangedParameters.append(parameter.name.name())
        parameters.append(ParsedTypeReference(parameter.type))
      }
      explicitResultType = .action(parameters: parameters, returnValue: type)
    } else {
      explicitResultType = type
    }
    switch use.action {
    case .referenced(let referenced):
      return ActionUse.construct(referenced).map { action in
        var annotated = action
        annotated.passage = passage
        annotated.rearrangedParameters = rearrangedParameters
        annotated.explicitResultType = explicitResultType
        return annotated
      }
    case .literal(let literal):
      return StatementListIntermediate.construct(literal).map { statements in
        return ActionUse(
          actionName: "",
          arguments: [],
          isList: false,
          actionLiteral: ActionLiteralIntermediate(implementation: statements),
          passage: passage,
          explicitResultType: explicitResultType,
          rearrangedParameters: rearrangedParameters
        )
      }
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
    referenceLookup: [ReferenceDictionary],
    context: ActionIntermediate?
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
            return preceding + [guess]
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
    if let actionLiteral = actionLiteral {
      self.actionLiteral?.resolveTypes(
        parameters: actionLiteral.parameterDictionary(
          rearrangedParameters: rearrangedParameters,
          explicitSignature: explicitResultType!,
          referenceLookup: referenceLookup
        ),
        returnType: actionLiteral.returnType(explicitSignature: explicitResultType!),
        context: context,
        referenceLookup: referenceLookup
      )
      return .resolved(.some(explicitResultType))
    }
    return .failed
  }
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary],
    specifiedReturnValue: ParsedTypeReference??,
    finalReturnValue: ParsedTypeReference?
  ) {
    var local = ReferenceDictionary(scope: .local)
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
        referenceLookup: referenceLookup + [local],
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
    let referenceLookupWithFlowLocals = referenceLookup + [local]
    switch specifiedReturnValue {
    case .some(.some(let value)):
      resolvedResultType = value
      if arguments.contains(where: { $0.resolvedResultType == nil })
        || actionLiteral != nil {
        _ = resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookupWithFlowLocals,
          context: context
        )
      }
    case .some(.none):
      resolvedResultType = .some(.none)
      if arguments.contains(where: { $0.resolvedResultType == nil }) {
        _ = resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookupWithFlowLocals,
          context: context
        )
      }
    case .none:
      if isList {
        let resolved: [ParsedTypeReference] = arguments.compactMap({ $0.resolvedResultType ?? nil })
        if resolved.areAllEqual(by: { entry in
          return referenceLookup.lookupThing(entry.key)?
            .globallyUniqueIdentifier(referenceLookup: referenceLookup)
        }) {
          resolvedEntryType = resolved.first
        } else {
          let explicit: [ParsedTypeReference] = arguments.compactMap({ $0.explicitResultType })
          if explicit.areAllEqual(by: { entry in
            return referenceLookup.lookupThing(entry.key)?
              .globallyUniqueIdentifier(referenceLookup: referenceLookup)
          }) {
            resolvedEntryType = explicit.first
          }
        }
        if let resolvedEntryType = resolvedEntryType {
          for index in arguments.indices {
            if arguments[index].explicitResultType == nil {
              arguments[index].resolvedResultType = resolvedEntryType
            }
          }
          resolvedResultType = ParsedTypeReference.compilerGeneratedReferenceToList(of: resolvedEntryType)
        }
      } else if let parameter = context?.lookupParameter(actionName) {
        resolvedResultType = parameter.type
        if arguments.contains(where: { $0.resolvedResultType == nil }) {
          _ = resolveArgumentTypes(
            specifiedReturnValue: specifiedReturnValue,
            referenceLookup: referenceLookupWithFlowLocals,
            context: context
          )
        }
      } else {
        switch resolveArgumentTypes(
          specifiedReturnValue: specifiedReturnValue,
          referenceLookup: referenceLookupWithFlowLocals,
          context: context
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
    var local = ReferenceDictionary(scope: .local)
    for argument in arguments {
      argument.validateReferences(
        context: context + [local],
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
      if let literal = literal {
        if let resolved = resolvedResultType,
           let reference = resolved,
           let type = context.lookupThing(reference.key) {
          literal.validate(
            as: type,
            reference: reference,
            errors: &errors
          )
        }
      } else if isList {
        if let resolved = resolvedEntryType,
          let entryType = context.lookupThing(resolved.key) {
          let identifier = entryType.globallyUniqueIdentifier(referenceLookup: context)
          for argument in arguments {
            if let resolved = argument.resolvedResultType,
               let reference = resolved,
               let type = context.lookupThing(reference.key) {
              if type.globallyUniqueIdentifier(referenceLookup: context) != identifier {
                errors.append(.incompatibleListEntry(argument.source!))
              }
            }
          }
        }
      } else if let actionLiteral = actionLiteral {
        actionLiteral.validateReferences(
          parameters: actionLiteral.parameterDictionary(
            rearrangedParameters: rearrangedParameters,
            explicitSignature: explicitResultType!,
            referenceLookup: context
          ),
          context: context,
          testContext: testContext,
          allowTestOnly: allowTestOnly,
          errors: &errors
        )
      } else {
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
      isList: isList,
      actionLiteral: actionLiteral?.resolvingExtensionContext(typeLookup: typeLookup),
      source: source,
      passage: passage,
      explicitResultType: explicitResultType
        .flatMap({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
      resolvedResultType: resolvedResultType
        .flatMap({ $0?.resolvingExtensionContext(typeLookup: typeLookup) }),
      rearrangedParameters: rearrangedParameters,
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
      isList: isList,
      actionLiteral: actionLiteral?.specializing(typeLookup: typeLookup),
      source: source,
      passage: passage,
      explicitResultType: explicitResultType.flatMap({ $0.specializing(typeLookup: typeLookup) }),
      resolvedResultType: resolvedResultType.flatMap({ $0?.specializing(typeLookup: typeLookup) }),
      rearrangedParameters: rearrangedParameters,
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
  func coverageSubregions() -> [UnicodeText?] {
    if let action = actionLiteral {
      return [action.implementation.openingBrace?.location.stableEndLocation()]
        + action.implementation.coverageSubregions()
    } else {
      return arguments.flatMap { $0.coverageSubregions() }
    }
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
          specifiedReturnValue: resolvedResultType),
        !action.isParameterWrapper {
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
    if isList {
      result.append(contentsOf: requiredIdentifiersForListLiteral(context: context))
    }
    if let actionLiteral = self.actionLiteral,
      case .action(let parameters, let returnType) = explicitResultType {
      for parameter in parameters {
        result.append(contentsOf: parameter.requiredIdentifiers(moduleAndExternalReferenceLookup: context))
      }
      returnType.map { type in
        result.append(contentsOf: type.requiredIdentifiers(moduleAndExternalReferenceLookup: context))
      }
      result.append(
        contentsOf: actionLiteral.implementation.requiredIdentifiers(
          context: context + [actionLiteral.parameterDictionary(
            rearrangedParameters: rearrangedParameters,
            explicitSignature: explicitResultType!,
            referenceLookup: context
          )]
        )
      )
    }
    return result
  }
  func requiredIdentifiersForListLiteral(
    context: [ReferenceDictionary]
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
    if let entry = resolvedEntryType,
       let thing = context.lookupThing(entry.key) {
      let entryComponents = thing.unresolvedGloballyUniqueIdentifierComponents()
      var unresolved: [UnicodeText] = [
        "list literal () ending at ()",
        "(",
        "list literal of unknown length containing ()",
      ]
      unresolved.append(contentsOf: entryComponents)
      unresolved.append(contentsOf: [
        ")",
        "memory offset",
        "(",
        "list of ()",
      ])
      unresolved.append(contentsOf: entryComponents)
      unresolved.append(contentsOf: [
        ")",
      ])
      result.append(
        Thing.resolve(globallyUniqueIdentifierComponents: unresolved, referenceLookup: context)
      )
    }
    return result
  }
}
