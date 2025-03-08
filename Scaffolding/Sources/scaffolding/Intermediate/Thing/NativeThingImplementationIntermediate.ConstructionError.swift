extension NativeThingImplementationIntermediate {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)
    case nativeExpressionError(NativeActionExpressionIntermediate.ConstructionError)
    case nativeRequirementError(NativeRequirementImplementationIntermediate.ConstructionError)

    var range: Slice<UnicodeSegments> {
      switch self {
      case .literalError(let error):
        return error.range
      case .nativeExpressionError(let error):
        return error.range
      case .nativeRequirementError(let error):
        return error.range
      }
    }
  }
}
