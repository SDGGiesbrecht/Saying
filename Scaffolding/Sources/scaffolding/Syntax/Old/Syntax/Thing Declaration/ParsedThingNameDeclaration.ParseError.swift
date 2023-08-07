extension ParsedThingNameDeclaration {

  enum ParseError: Error {
    case parenthesisMissing(UTF8Segments.Index)
    case unexpectedTextOnSameLineAsParenthesis
    case entryParseError(
      ParsedDictionaryEntry<ParsedUninterruptedIdentifier, ParsedUninterruptedIdentifier>.ParseError
    )
  }
}
