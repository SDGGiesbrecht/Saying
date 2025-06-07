struct StatementIntermediate {
  var isReturn: Bool
  var action: ActionUse?
  var isDeadEnd: Bool {
    return action == nil
  }
}

extension StatementIntermediate {
  static func construct(_ statement: ParsedStatement) -> Result<StatementIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    var errors: [LiteralIntermediate.ConstructionError] = []
    let isReturn: Bool
    let action: ActionUse?
    switch statement {
    case .valid(let valid):
      isReturn = valid.yieldArrow != nil
      switch ActionUse.construct(valid.action) {
      case .failure(let error):
        errors.append(contentsOf: error.errors)
        action = nil
      case .success(let constructed):
        action = constructed
      }
    case .deadEnd:
      isReturn = false
      action = nil
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(StatementIntermediate(isReturn: isReturn, action: action))
  }
}

extension StatementIntermediate {
  func localActions() -> [ActionIntermediate] {
    return action?.localActions() ?? []
  }
  func passedReferences() -> [ActionUse] {
    return action?.passedReferences() ?? []
  }
}

extension StatementIntermediate {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary],
    finalReturnValue: ParsedTypeReference?
  ) {
    action?.resolveTypes(
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
    action?.validateReferences(
      context: context,
      testContext: testContext,
      errors: &errors
    )
  }
}

extension StatementIntermediate {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> StatementIntermediate {
    return StatementIntermediate(
      isReturn: isReturn,
      action: action?.resolvingExtensionContext(typeLookup: typeLookup)
    )
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> StatementIntermediate {
    return StatementIntermediate(
      isReturn: isReturn,
      action: action?.specializing(typeLookup: typeLookup)
    )
  }
}

extension StatementIntermediate {
  func coverageSubregions(
    counter: inout Int,
    followingStatements: Array<StatementIntermediate>.SubSequence
  ) -> [Int] {
    var list: [Int] = []
    let before = counter
    list.append(contentsOf: action?.coverageSubregions(counter: &counter) ?? [])
    if counter != before {
      counter += 1 // afterward (since could have returned)
      if followingStatements.first?.isDeadEnd != true {
        list.append(counter)
      }
    }
    return list
  }
}

extension StatementIntermediate {

  func requiredIdentifiers(
    context: [ReferenceDictionary]
  ) -> [UnicodeText] {
    return action?.requiredIdentifiers(
      context: context
    ) ?? []
  }
}
