struct StatementListIntermediate {
  var statements: [ActionUse]
  var localActions: [ActionIntermediate]
}

extension StatementListIntermediate {
  init(_ statements: ParsedStatementList) {
    let constructedStatements = statements.statements.map { ActionUse($0) }
    self.statements = constructedStatements
    self.localActions = constructedStatements.flatMap { $0.localActions() }
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
        specifiedReturnValue: index == statements.indices.last ? .some(finalReturnValue) : .some(.none)
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
        #warning("Dropping errors.")
        _ = local.add(action: new)
      }
    }
  }
}
