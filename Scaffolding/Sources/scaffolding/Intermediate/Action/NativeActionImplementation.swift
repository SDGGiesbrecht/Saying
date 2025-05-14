import SDGText

struct NativeActionImplementationIntermediate {
  var expression: NativeActionExpressionIntermediate
  var requiredImports: [UnicodeText] = []
  var indirectRequirements: [NativeRequirementImplementationIntermediate] = []
  var requiredDeclarations: [NativeRequirementImplementationIntermediate] = []
}

extension NativeActionImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeAction
  ) -> Result<NativeActionImplementationIntermediate, ErrorList<ConstructionError>> {
    var errors: [ConstructionError] = []
    let expression: NativeActionExpressionIntermediate
    switch NativeActionExpressionIntermediate.construct(
      expression: implementation.expression
    ) {
    case .failure(let error):
      errors.append(contentsOf: error.errors.map({ ConstructionError.nativeExpressionError($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      expression = constructed
    }
    var requiredImports: [UnicodeText] = []
    for importLiteral in implementation.importNode?.imports.imports ?? [] {
      switch LiteralIntermediate.construct(literal: importLiteral) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
      case .success(let literal):
        requiredImports.append(UnicodeText(StrictString(literal.string)))
      }
    }
    var indirectRequirments: [NativeRequirementImplementationIntermediate] = []
    for requirement in implementation.indirectNode?.requirements.requirements ?? [] {
      switch NativeRequirementImplementationIntermediate.construct(implementation: requirement) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.nativeRequirementError($0) }))
      case .success(let constructed):
        indirectRequirments.append(constructed)
      }
    }
    var requiredDeclarations: [NativeRequirementImplementationIntermediate] = []
    for requirement in implementation.code?.requirements.requirements ?? [] {
      switch NativeRequirementImplementationIntermediate.construct(implementation: requirement) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.nativeRequirementError($0) }))
      case .success(let constructed):
        requiredDeclarations.append(constructed)
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      NativeActionImplementationIntermediate(
        expression: expression,
        requiredImports: requiredImports,
        indirectRequirements: indirectRequirments,
        requiredDeclarations: requiredDeclarations
      )
    )
  }
}

extension NativeActionImplementationIntermediate {
  func specializing(
    implementationTypeLookup: [StrictString: ParsedTypeReference],
    requiredDeclarationTypeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeActionImplementationIntermediate {
    return NativeActionImplementationIntermediate(
      expression: expression.specializing(typeLookup: implementationTypeLookup),
      requiredImports: requiredImports,
      indirectRequirements: indirectRequirements.map({ $0.specializing(typeLookup: requiredDeclarationTypeLookup) }),
      requiredDeclarations: requiredDeclarations.map({ $0.specializing(typeLookup: requiredDeclarationTypeLookup) })
    )
  }
}
