extension NativeActionExpressionIntermediate {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)

    var range: SayingSourceSlice {
      switch self {
      case .literalError(let error):
        return error.range
      }
    }
  }
}
