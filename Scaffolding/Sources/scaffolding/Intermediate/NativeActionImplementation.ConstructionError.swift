extension NativeActionImplementationIntermediate {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)
    case parenthesesMissing(ParsedNativeActionExpression)
    case parameterNotFound(ParsedUninterruptedIdentifier)

    var range: Slice<UTF8Segments> {
      switch self {
      case .literalError(let error):
        return error.range
      case .parenthesesMissing(let expression):
        return expression.location
      case .parameterNotFound(let identifier):
        return identifier.location
      }
    }
  }
}
