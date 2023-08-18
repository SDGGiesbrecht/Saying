extension SwiftImplementation {
  enum ConstructionError: Error {
    case literalError(LiteralIntermediate.ConstructionError)
    case parameterNotFound(ParsedUninterruptedIdentifier)
  }
}
