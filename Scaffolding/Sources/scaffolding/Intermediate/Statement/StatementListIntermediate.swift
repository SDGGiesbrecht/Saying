import SDGText

struct StatementListIntermediate {
  var statements: [StatementIntermediate]
}

extension StatementListIntermediate {
  init(_ statements: ParsedBracedStatementList) {
    self.statements = statements.statements.map { StatementIntermediate($0) }
  }
}

extension StatementListIntermediate {
  mutating func resolveTypes(
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary],
    finalReturnValue: ParsedTypeReference?
  ) {
    var locals = ReferenceDictionary()
    for index in statements.indices {
      statements[index].resolveTypes(
        context: context,
        referenceLookup: referenceLookup.appending(locals),
        finalReturnValue: finalReturnValue
      )
      let newActions = statements[index].localActions()
      for new in newActions {
        _ = locals.add(action: new)
      }
      if !newActions.isEmpty {
        locals.resolveTypeIdentifiers(externalLookup: referenceLookup)
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
        testContext: testContext,
        errors: &errors
      )
      let newActions = statement.localActions()
      for new in newActions {
        errors.append(contentsOf: local.add(action: new).map({ .redeclaredLocalIdentifier(error: $0) }))
      }
      if !newActions.isEmpty {
        local.resolveTypeIdentifiers(externalLookup: context)
      }
    }
  }
}

extension StatementListIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: UnicodeText]
  ) -> StatementListIntermediate {
    return StatementListIntermediate(
      statements: statements.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> StatementListIntermediate {
    return StatementListIntermediate(
      statements: statements.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}

extension StatementListIntermediate {
  func coverageSubregions(counter: inout Int) -> [Int] {
    return statements.indices.flatMap { index in
      return statements[index].coverageSubregions(
        counter: &counter,
        followingStatements: statements[index...].dropFirst()
      )
    }
  }
}

extension StatementListIntermediate {

  func requiredIdentifiers(
    context: [ReferenceDictionary]
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
    for statement in statements {
      result.append(
        contentsOf: statement.requiredIdentifiers(
          context: context
        )
      )
    }
    return result
  }
}
