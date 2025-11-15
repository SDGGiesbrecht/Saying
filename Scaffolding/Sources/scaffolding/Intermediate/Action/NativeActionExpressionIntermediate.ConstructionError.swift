extension NativeActionExpressionIntermediate {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)
    case parameterError(NativeActionImplementationParameter.ConstructionError)

    var range: SayingSourceSlice {
      switch self {
      case .literalError(let error):
        return error.range
      case .parameterError(let error):
        return error.range
      }
    }
  }
}
