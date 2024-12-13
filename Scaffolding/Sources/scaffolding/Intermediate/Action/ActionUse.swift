import SDGLogic
import SDGText

struct ActionUse {
  var actionName: StrictString
  var arguments: [ActionUseArgument]
  var source: ParsedAction?
  var passage: ParameterPassage
  var explicitResultType: ParsedTypeReference?
  var resolvedResultType: ParsedTypeReference??
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
    case .some(.none):
      resolvedResultType = .some(.none)
    case .none:
      guard let signature = arguments.mapAll({ $0.resolvedResultType })?.mapAll({ $0 }) else {
        return // aborting due to failure deeper down
      }
      if let parameter = context?.lookupParameter(actionName) {
        resolvedResultType = parameter.type
      } else if let action = referenceLookup.lookupAction(
        actionName,
        signature: signature,
        specifiedReturnValue: specifiedReturnValue
      ) {
        resolvedResultType = action.returnValue
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
