extension InterfaceSyntax.Declaration {

  enum CommonParseError: Error {
    case keywordMissing
    case mismatchedKeyword(OldParsedToken)
    case unexpectedTextAfterKeyword([OldParsedToken])
    case nestingError(ParsedNestingNodeParseError<Deferred>)
    case detailsMissing(UTF8Segments.Index)
  }
}
