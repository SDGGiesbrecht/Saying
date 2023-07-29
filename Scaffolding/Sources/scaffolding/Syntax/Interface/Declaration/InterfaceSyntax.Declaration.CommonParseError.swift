extension InterfaceSyntax.Declaration {

  enum CommonParseError: Error {
    case keywordMissing
    case mismatchedKeyword(ParsedToken)
    case unexpectedTextAfterKeyword([ParsedToken])
    case detailsMissing(ParsedToken)
  }
}
