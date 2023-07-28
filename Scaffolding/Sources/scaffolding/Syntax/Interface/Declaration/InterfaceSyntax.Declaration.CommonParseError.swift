extension InterfaceSyntax.Declaration {

  enum CommonParseError: Error {
    case keywordMissing
    case mismatchedKeyword(ParsedToken)
    case noLineBreakAfterKeyword(UTF8Segments.Index)
  }
}
