import SDGLogic
import SDGText

struct ActionUse {
  var actionName: StrictString
  var arguments: [ActionUse]
  var source: ParsedAction?
  var explicitResultType: StrictString?
  var resolvedResultType: StrictString??
}

extension ActionUse {

  init(_ use: ParsedAction) {
    actionName = use.name()
    switch use {
    case .compound(let compound):
      arguments = compound.arguments.arguments.map { ActionUse($0.argument) }
    case .simple:
      arguments = []
    }
    source = use
  }

  init(_ use: ParsedAnnotatedAction) {
    self = ActionUse(use.action)
    explicitResultType = use.type?.type.identifierText()
  }

  mutating func resolveTypes(
    context: ActionIntermediate?,
    module: ModuleIntermediate,
    specifiedReturnValue: StrictString??
  ) {
    for index in arguments.indices {
      let explicitArgumentReturnValue: StrictString??
      switch arguments[index].explicitResultType {
      case .some(let specified):
        explicitArgumentReturnValue = .some(.some(specified))
      case .none:
        explicitArgumentReturnValue = .none
      }
      arguments[index].resolveTypes(
        context: context,
        module: module,
        specifiedReturnValue: explicitArgumentReturnValue
      )
    }
    switch specifiedReturnValue {
    case .some(.some(let value)):
      resolvedResultType = value
    case .some(.none):
      resolvedResultType = .none
    case .none:
      let signature = arguments.compactMap({ $0.resolvedResultType }).compactMap({ $0 })
      guard signature.count == arguments.count else {
        return // aborting due to failure deeper down
      }
      if let parameter = context?.lookupParameter(actionName) {
        resolvedResultType = parameter.type
      } else if let action = module.lookupAction(
        actionName,
        signature: signature,
        specifiedReturnValue: specifiedReturnValue
      ) {
        resolvedResultType = action.returnValue
      }
    }
  }

  func validateReferences(context: [Scope], testContext: Bool, errors: inout [ReferenceError]) {
    for argument in arguments {
      argument.validateReferences(context: context, testContext: testContext, errors: &errors)
    }
    let signature = arguments.compactMap({ $0.resolvedResultType }).compactMap({ $0 })
    if signature.count == arguments.count,
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

extension ActionUse {

  func specializing(
    typeLookup: [StrictString: StrictString]
  ) -> ActionUse {
    return ActionUse(
      actionName: actionName,
      arguments: arguments.map({ $0.specializing(typeLookup: typeLookup) }),
      source: source,
      explicitResultType: explicitResultType.flatMap({ typeLookup[$0] ?? $0 })
    )
  }
}
