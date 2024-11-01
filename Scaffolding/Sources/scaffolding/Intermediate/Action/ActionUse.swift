import SDGLogic
import SDGText

struct ActionUse {
  var actionName: StrictString
  var arguments: [ActionUse]
  var source: ParsedAction?
  var explicitResultType: ParsedTypeReference?
  var resolvedResultType: ParsedTypeReference??
}

extension ActionUse {

  init(_ use: ParsedAction) {
    actionName = use.name()
    switch use {
    case .compound(let compound):
      arguments = compound.arguments.arguments.map { ActionUse($0.argument) }
    case .reference:
      arguments = []
    case .simple:
      arguments = []
    }
    source = use
  }

  init(_ use: ParsedAnnotatedAction) {
    self = ActionUse(use.action)
    let type = use.type.map({ ParsedTypeReference($0.type) })
    if use.type?.yieldArrow ≠ nil {
      explicitResultType = .action(parameters: [], returnValue: type)
    } else {
      explicitResultType = type
    }
  }

  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceDictionary: ReferenceDictionary,
    specifiedReturnValue: ParsedTypeReference??
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
        referenceDictionary: referenceDictionary,
        specifiedReturnValue: explicitArgumentReturnValue
      )
    }
    switch specifiedReturnValue {
    case .some(.some(let value)):
      resolvedResultType = value
    case .some(.none):
      resolvedResultType = .none
    case .none:
      guard let signature = arguments.mapAll({ $0.resolvedResultType })?.mapAll({ $0 }) else {
        return // aborting due to failure deeper down
      }
      if let parameter = context?.lookupParameter(actionName) {
        resolvedResultType = parameter.type
      } else if let action = referenceDictionary.lookupAction(
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
    for argument in arguments {
      argument.validateReferences(context: context, testContext: testContext, errors: &errors)
    }
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

extension ActionUse {

  func specializing(
    typeLookup: [StrictString: SimpleTypeReference]
  ) -> ActionUse {
    return ActionUse(
      actionName: actionName,
      arguments: arguments.map({ $0.specializing(typeLookup: typeLookup) }),
      source: source,
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
