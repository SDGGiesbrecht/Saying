extension InterfaceSyntax.Declaration {

  enum CommonParseError: Error {
    case keywordMissing
    case mismatchedKeyword(ParsedToken)
    case unexpectedTextAfterKeyword([ParsedToken])
    case nestingError(ParsedNestingNodeParseError<Deferred>)
    case detailsMissing(UTF8Segments.Index)
  }
}
