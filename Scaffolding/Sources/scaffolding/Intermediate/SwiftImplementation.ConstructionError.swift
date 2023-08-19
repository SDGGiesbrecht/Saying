extension SwiftImplementation {
  enum ConstructionError: Error {
    case literalError(LiteralIntermediate.ConstructionError)
    case parenthesesMissing([ParsedImplementationComponent])
    case parameterNotFound(ParsedUninterruptedIdentifier)
  }
}
