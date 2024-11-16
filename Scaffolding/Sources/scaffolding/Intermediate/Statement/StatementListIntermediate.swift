struct StatementListIntermediate {
  var statements: [StatementIntermediate]
}

extension StatementListIntermediate {
  init(_ statements: ParsedStatementList) {
    self.statements = statements.statements.map { StatementIntermediate($0) }
  }
}

extension StatementListIntermediate {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceDictionary: ReferenceDictionary,
    finalReturnValue: ParsedTypeReference?
  ) {
    var adjustedReferences = referenceDictionary
    for index in statements.indices {
      statements[index].resolveTypes(
        context: context,
        referenceDictionary: adjustedReferences,
        finalReturnValue: finalReturnValue
      )
      for new in statements[index].localActions() {
        _ = adjustedReferences.add(action: new)
      }
    }
  }

  func validateReferences(
    context: [ReferenceDictionary],
    testContext: Bool,
    errors: inout [ReferenceError]
  ) {
    var local = ReferenceDictionary()
    for statement in statements {
      statement.validateReferences(
        context: context.appending(local),
        testContext: false,
        errors: &errors
      )
      for new in statement.localActions() {
        errors.append(contentsOf: local.add(action: new).map({ .redeclaredLocalIdentifier(error: $0) }))
      }
    }
  }
}
