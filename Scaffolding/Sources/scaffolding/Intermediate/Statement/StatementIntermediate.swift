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
}

extension StatementIntermediate {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceDictionary: ReferenceDictionary,
    finalReturnValue: ParsedTypeReference?
  ) {
    action.resolveTypes(
      context: context,
      referenceDictionary: referenceDictionary,
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
    typeLookup: [StrictString: SimpleTypeReference]
  ) -> StatementIntermediate {
    return StatementIntermediate(
      isReturn: isReturn,
      action: action.specializing(typeLookup: typeLookup)
    )
  }
}

extension StatementIntermediate {
  func countCoverageSubregions(count: inout Int) {
    action.countCoverageSubregions(count: &count)
  }
}
