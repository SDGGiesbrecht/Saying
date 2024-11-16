import SDGText

enum ActionUseArgument {
  case action(ActionUse)
  case flow(StatementListIntermediate)
}

extension ActionUseArgument {
  var explicitResultType: ParsedTypeReference? {
    switch self {
    case .action(let action):
      return action.explicitResultType
    case .flow:
      return nil
    }
  }
  var resolvedResultType: ParsedTypeReference?? {
    switch self {
    case .action(let action):
      return action.resolvedResultType
    case .flow:
      return .some(.none)
    }
  }
}

extension ActionUseArgument {
  func localActions() -> [ActionIntermediate] {
    switch self {
    case .action(let action):
      return action.localActions()
    case .flow:
      return []
    }
  }
}

extension ActionUseArgument {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceDictionary: ReferenceDictionary,
    specifiedReturnValue: ParsedTypeReference??,
    finalReturnValue: ParsedTypeReference?
  ) {
    switch self {
    case .action(var action):
      action.resolveTypes(
        context: context,
        referenceDictionary: referenceDictionary,
        specifiedReturnValue: specifiedReturnValue,
        finalReturnValue: finalReturnValue
      )
      self = .action(action)
    case .flow(var statements):
      statements.resolveTypes(
        context: context,
        referenceDictionary: referenceDictionary,
        finalReturnValue: finalReturnValue
      )
    }
  }

  func validateReferences(
    context: [ReferenceDictionary],
    testContext: Bool,
    errors: inout [ReferenceError]
  ) {
    switch self {
    case .action(let action):
      action.validateReferences(context: context, testContext: testContext, errors: &errors)
    case .flow(let statements):
      statements.validateReferences(context: context, testContext: testContext, errors: &errors)
    }
  }
}

extension ActionUseArgument {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> ActionUseArgument {
    switch self {
    case .action(let action):
      return .action(action.resolvingExtensionContext(typeLookup: typeLookup))
    case .flow(let statements):
      return .flow(statements.resolvingExtensionContext(typeLookup: typeLookup))
    }
  }

  func specializing(
    typeLookup: [StrictString: SimpleTypeReference]
  ) -> ActionUseArgument {
    switch self {
    case .action(let action):
      return .action(action.specializing(typeLookup: typeLookup))
    case .flow(let statements):
      return .flow(statements.specializing(typeLookup: typeLookup))
    }
  }
}
