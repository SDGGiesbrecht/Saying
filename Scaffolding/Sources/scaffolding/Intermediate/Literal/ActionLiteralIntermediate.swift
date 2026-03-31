struct ActionLiteralIntermediate {
  var implementation: StatementListIntermediate
}

extension ActionLiteralIntermediate {
  mutating func resolveTypes(
    parameters: ReferenceDictionary,
    returnType: ParsedTypeReference?,
    context: ActionIntermediate?,
    referenceLookup: [ReferenceDictionary]
  ) {
    implementation.resolveTypes(
      context: context,
      referenceLookup: referenceLookup.appending(parameters),
      finalReturnValue: returnType
    )
  }

  func validateReferences(
    parameters: ReferenceDictionary,
    context: [ReferenceDictionary],
    testContext: TestContext?,
    allowTestOnly: Bool,
    errors: inout [ReferenceError]
  ) {
    implementation.validateReferences(
      context: context.appending(parameters),
      testContext: testContext,
      allowTestOnly: allowTestOnly,
      errors: &errors
    )
  }
}

extension ActionLiteralIntermediate {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> ActionLiteralIntermediate {
    return ActionLiteralIntermediate(
      implementation: implementation.resolvingExtensionContext(typeLookup: typeLookup)
    )
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> ActionLiteralIntermediate {
    return ActionLiteralIntermediate(
      implementation: implementation.specializing(typeLookup: typeLookup)
    )
  }
}

extension ActionLiteralIntermediate {

  func parameterDictionary(
    rearrangedParameters: [UnicodeText],
    explicitSignature: ParsedTypeReference,
    referenceLookup: [ReferenceDictionary]
  ) -> ReferenceDictionary {
    var result = ReferenceDictionary()
    guard case .action(let parameters, _) = explicitSignature else {
      fatalError()
    }
    for (name, type) in zip(rearrangedParameters, parameters) {
      _ = result.add(
        action: .parameterAction(
          names: [name],
          parameters: .none,
          returnValue: type
        )
      )
    }
    result.resolveTypeIdentifiers(externalLookup: referenceLookup)
    return result
  }

  func returnType(
    explicitSignature: ParsedTypeReference
  ) -> ParsedTypeReference? {
    guard case .action(_, let returnType) = explicitSignature else {
      fatalError()
    }
    return returnType
  }
}
