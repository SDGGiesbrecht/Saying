extension NativeActionImplementationIntermediate {
  enum ConstructionError: DiagnosticError {
    case nativeExpressionError(NativeActionExpressionIntermediate.ConstructionError)
    case literalError(LiteralIntermediate.ConstructionError)
    case nativeRequirementError(NativeRequirementImplementationIntermediate.ConstructionError)

    var range: SayingSourceSlice {
      switch self {
      case .nativeExpressionError(let error):
        return error.range
      case .literalError(let error):
        return error.range
      case .nativeRequirementError(let error):
        return error.range
      }
    }
  }
}
