import SDGText

struct StatementIntermediate {
  var isReturn: Bool
  var action: ActionUse
}

extension StatementIntermediate {
  init(_ statement: ParsedStatement) {
    isReturn = statement.yieldArrow != nil
    action = ActionUse(statement.action)
  }
}

extension StatementIntermediate {
  func localActions() -> [ActionIntermediate] {
    return action.localActions()
  }
  func passedReferences() -> [ActionUse] {
    return action.passedReferences()
  }
}

extension StatementIntermediate {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary],
    finalReturnValue: ParsedTypeReference?
  ) {
    action.resolveTypes(
      context: context,
      referenceLookup: referenceLookup,
      specifiedReturnValue: isReturn ? .some(finalReturnValue) : .some(.none),
      finalReturnValue: finalReturnValue
    )
  }

  func validateReferences(
    context: [ReferenceDictionary],
    testContext: Bool,
    errors: inout [ReferenceError]
  ) {
    action.validateReferences(
      context: context,
      testContext: testContext,
      errors: &errors
    )
  }
}

extension StatementIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> StatementIntermediate {
    return StatementIntermediate(
      isReturn: isReturn,
      action: action.resolvingExtensionContext(typeLookup: typeLookup)
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> StatementIntermediate {
    return StatementIntermediate(
      isReturn: isReturn,
      action: action.specializing(typeLookup: typeLookup)
    )
  }
}

extension StatementIntermediate {
  func countCoverageSubregions(count: inout Int) {
    let before = count
    action.countCoverageSubregions(count: &count)
    if count != before {
      count += 1 // afterward (since could have returned)
    }
  }
}

extension StatementIntermediate {

  func requiredIdentifiers(
    context: [ReferenceDictionary]
  ) -> [StrictString] {
    return action.requiredIdentifiers(
      context: context
    )
  }
}
