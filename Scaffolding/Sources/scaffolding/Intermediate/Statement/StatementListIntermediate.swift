struct StatementListIntermediate {
  var statements: [ActionUse]
}

extension StatementListIntermediate {
  init(_ statements: ParsedStatementList) {
    self.statements = statements.statements.map { ActionUse($0) }
  }
}

extension StatementListIntermediate {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceDictionary: ReferenceDictionary,
    finalReturnValue: ParsedTypeReference?
  ) {
    for index in statements.indices {
      statements[index].resolveTypes(
        context: context,
        referenceDictionary: referenceDictionary,
        specifiedReturnValue: index == statements.indices.last ? .some(finalReturnValue) : .some(.none)
      )
    }
  }

  func validateReferences(
    context: [ReferenceDictionary],
    testContext: Bool,
    errors: inout [ReferenceError]
  ) {
    for statement in statements {
      statement.validateReferences(
        context: context,
        testContext: false,
        errors: &errors
      )
    }
  }
}
