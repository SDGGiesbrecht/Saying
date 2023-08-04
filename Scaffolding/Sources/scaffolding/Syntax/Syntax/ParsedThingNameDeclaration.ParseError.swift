extension ParsedThingNameDeclaration {

  enum ParseError: Error {
    case parenthesisMissing(UTF8Segments.Index)
    case unexpectedTextOnSameLineAsParenthesis
  }
}
