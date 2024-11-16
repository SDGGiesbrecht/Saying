import SDGText

enum ActionUseArgument {
  case action(ActionUse)
  case flow
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
    specifiedReturnValue: ParsedTypeReference??
  ) {
    switch self {
    case .action(var action):
      action.resolveTypes(
        context: context,
        referenceDictionary: referenceDictionary,
        specifiedReturnValue: specifiedReturnValue
      )
      self = .action(action)
    case .flow:
      #warning("Not implemented yet.")
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
    case .flow:
      #warning("Not implemented yet.")
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
    case .flow:
      #warning("Not implemented yet.")
      return .flow
    }
  }

  func specializing(
    typeLookup: [StrictString: SimpleTypeReference]
  ) -> ActionUseArgument {
    switch self {
    case .action(let action):
      return .action(action.specializing(typeLookup: typeLookup))
    case .flow:
      #warning("Not implemented yet.")
      return .flow
    }
  }
}
