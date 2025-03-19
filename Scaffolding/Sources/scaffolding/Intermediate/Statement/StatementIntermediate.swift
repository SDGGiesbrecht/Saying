import SDGText

struct StatementIntermediate {
  var isReturn: Bool
  var action: ActionUse?
  var isDeadEnd: Bool {
    return action == nil
  }
}

extension StatementIntermediate {
  init(_ statement: ParsedStatement) {
    switch statement {
    case .valid(let valid):
      isReturn = valid.yieldArrow != nil
      action = ActionUse(valid.action)
    case .deadEnd:
      isReturn = false
      action = nil
    }
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
    typeLookup: [StrictString: UnicodeText]
  ) -> StatementIntermediate {
    return StatementIntermediate(
      isReturn: isReturn,
      action: action?.resolvingExtensionContext(typeLookup: typeLookup)
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
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
