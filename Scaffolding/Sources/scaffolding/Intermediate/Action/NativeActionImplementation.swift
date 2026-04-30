struct NativeActionImplementationIntermediate {
  var expression: NativeActionExpressionIntermediate
  var requiredImports: [ImportIntermediate] = []
  var indirectRequirements: [NativeRequirementImplementationIntermediate] = []
  var requiredDeclarations: [NativeRequirementImplementationIntermediate] = []
  var condition: String?
}

extension NativeActionImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeAction,
    condition: ParsedAvailabilityCondition?
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
    var requiredImports: [ImportIntermediate] = []
    for importNode in implementation.importNode?.imports.imports ?? [] {
      switch ImportIntermediate.construct(importNode: importNode) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
      case .success(let constructed):
        requiredImports.append(constructed)
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
    var conditionString: String?
    if let parsed = condition?.condition {
      switch LiteralIntermediate.construct(literal: parsed) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
      case .success(let success):
        conditionString = success.string
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
        requiredDeclarations: requiredDeclarations,
        condition: conditionString
      )
    )
  }
}

extension NativeActionImplementationIntermediate {
  func specializing(
    implementationTypeLookup: [UnicodeText: ParsedTypeReference],
    requiredDeclarationTypeLookup: [UnicodeText: ParsedTypeReference]
  ) -> NativeActionImplementationIntermediate {
    return NativeActionImplementationIntermediate(
      expression: expression.specializing(typeLookup: implementationTypeLookup),
      requiredImports: requiredImports,
      indirectRequirements: indirectRequirements.map({ $0.specializing(typeLookup: requiredDeclarationTypeLookup) }),
      requiredDeclarations: requiredDeclarations.map({ $0.specializing(typeLookup: requiredDeclarationTypeLookup) }),
      condition: condition
    )
  }
}
