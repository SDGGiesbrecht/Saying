extension NativeThingImplementationIntermediate {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)
    case parameterError(NativeThingImplementationParameter.ConstructionError)
    case nativeExpressionError(NativeActionExpressionIntermediate.ConstructionError)
    case nativeRequirementError(NativeRequirementImplementationIntermediate.ConstructionError)

    var range: SayingSourceSlice {
      switch self {
      case .literalError(let error):
        return error.range
      case .parameterError(let error):
        return error.range
      case .nativeExpressionError(let error):
        return error.range
      case .nativeRequirementError(let error):
        return error.range
      }
    }
  }
}
