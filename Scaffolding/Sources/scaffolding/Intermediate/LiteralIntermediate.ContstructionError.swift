extension LiteralIntermediate {
  enum ConstructionError: Error {
    case escapeCodeNotHexadecimal(ParsedIdentifierComponent)
    case escapeCodeNotUnicodeScalar(ParsedIdentifierComponent)
  }
}
