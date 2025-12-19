struct NativeActionExpressionIntermediate {
  var textComponents: [UnicodeText]
  var parameters: [NativeActionImplementationParameter]
}

extension NativeActionExpressionIntermediate {

  static func construct(
    expression: ParsedNativeActionExpression
  ) -> Result<NativeActionExpressionIntermediate, ErrorList<ConstructionError>> {
    let components = expression.components
    var textComponents: [UnicodeText] = []
    var parameters: [NativeActionImplementationParameter] = []
    var errors: [ConstructionError] = []
    for index in components.indices {
      let element = components[index]
      switch element {
      case .parameter(let parameter):
        switch NativeActionImplementationParameter.construct(parameter) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.parameterError($0) }))
        case .success(let constructed):
          parameters.append(constructed)
        }
      case .literal(let literal):
        switch LiteralIntermediate.construct(literal: literal) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
        case .success(let literal):
          textComponents.append(UnicodeText(literal.string))
        }
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      NativeActionExpressionIntermediate(
        textComponents: textComponents,
        parameters: parameters
      )
    )
  }
}

extension NativeActionExpressionIntermediate {
  func validateReferences(
    availableParameters: [ParameterIntermediate],
    requiredAccess: AccessIntermediate,
    testContext: TestContext?,
    testOnlyAccess: Bool,
    referenceLookup: [ReferenceDictionary],
    errors: inout [ReferenceError]
  ) {
    for parameterReference in parameters {
      if let typeInstead = parameterReference.typeInstead {
        typeInstead.validateReferences(
          requiredAccess: requiredAccess,
          testContext: testContext,
          allowTestOnly: testOnlyAccess,
          referenceLookup: referenceLookup,
          errors: &errors
        )
      } else {
        if availableParameters.first(where: { $0.names.contains(parameterReference.name) }) == nil,
          !parameterReference.unique,
          !parameterReference.remainderOfScope {
          errors.append(.noSuchParameter(parameterReference.syntaxNode))
        }
      }
    }
  }
}

extension NativeActionExpressionIntermediate {
  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> NativeActionExpressionIntermediate {
    return NativeActionExpressionIntermediate(
      textComponents: textComponents,
      parameters: parameters.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
