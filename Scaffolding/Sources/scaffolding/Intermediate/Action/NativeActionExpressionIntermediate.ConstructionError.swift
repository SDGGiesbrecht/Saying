extension NativeActionExpressionIntermediate {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)

    var range: Slice<UnicodeSegments> {
      switch self {
      case .literalError(let error):
        return error.range
      }
    }
  }
}
