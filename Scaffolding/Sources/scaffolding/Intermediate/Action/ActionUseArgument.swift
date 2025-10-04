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
      return .statements
    }
  }
  var resolvedResultType: ParsedTypeReference?? {
    get {
      switch self {
      case .action(let action):
        return action.resolvedResultType
      case .flow:
        return .statements
      }
    }
    set {
      switch self {
      case .action(var action):
        action.resolvedResultType = newValue
        self = .action(action)
      case .flow:
        break
      }
    }
  }
  var narrowedResultTypes: [ParsedTypeReference?]? {
    switch self {
    case .action(let action):
      return action.narrowedResultTypes
    case .flow:
      return nil
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
  func passedReferences() -> [ActionUse] {
    switch self {
    case .action(let action):
      return action.passedReferences()
    case .flow:
      return []
    }
  }
}

extension ActionUseArgument {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary],
    specifiedReturnValue: ParsedTypeReference??,
    finalReturnValue: ParsedTypeReference?
  ) {
    switch self {
    case .action(var action):
      action.resolveTypes(
        context: context,
        referenceLookup: referenceLookup,
        specifiedReturnValue: specifiedReturnValue,
        finalReturnValue: finalReturnValue
      )
      self = .action(action)
    case .flow(var statements):
      statements.resolveTypes(
        context: context,
        referenceLookup: referenceLookup,
        finalReturnValue: finalReturnValue
      )
      self = .flow(statements)
    }
  }

  func validateReferences(
    context: [ReferenceDictionary],
    testContext: TestContext?,
    errors: inout [ReferenceError]
  ) {
    switch self {
    case .action(let action):
      action.validateReferences(
        context: context,
        testContext: testContext,
        errors: &errors
      )
    case .flow(let statements):
      statements.validateReferences(context: context, testContext: testContext, errors: &errors)
    }
  }
}

extension ActionUseArgument {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> ActionUseArgument {
    switch self {
    case .action(let action):
      return .action(action.resolvingExtensionContext(typeLookup: typeLookup))
    case .flow(let statements):
      return .flow(statements.resolvingExtensionContext(typeLookup: typeLookup))
    }
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> ActionUseArgument {
    switch self {
    case .action(let action):
      return .action(action.specializing(typeLookup: typeLookup))
    case .flow(let statements):
      return .flow(statements.specializing(typeLookup: typeLookup))
    }
  }
}

extension ActionUseArgument {
  func coverageSubregions(counter: inout Int) -> [Int] {
    var list: [Int] = []
    switch self {
    case .action:
      break
    case .flow(let statements):
      counter += 1
      if statements.statements.first?.isDeadEnd != true {
        list.append(counter)
      }
      list.append(contentsOf: statements.coverageSubregions(counter: &counter))
    }
    return list
  }
}

extension ActionUseArgument {

  func requiredIdentifiers(
    context: [ReferenceDictionary]
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
    switch self {
    case .action(let action):
      result.append(
        contentsOf: action.requiredIdentifiers(context: context)
      )
    case .flow(let statements):
      result.append(
        contentsOf: statements.requiredIdentifiers(
          context: context
        )
      )
    }
    return result
  }
}
