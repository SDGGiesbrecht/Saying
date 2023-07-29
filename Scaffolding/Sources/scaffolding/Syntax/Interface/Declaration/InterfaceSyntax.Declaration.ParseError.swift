extension InterfaceSyntax.Declaration {

  enum ParseError: Error {

    init?(_ error: InterfaceSyntax.Declaration.CommonParseError) {
      switch error {
      case .keywordMissing:
        self = .keywordMissing
      case .mismatchedKeyword:
        return nil
      case .unexpectedTextAfterKeyword(let text):
        self = .unexpectedTextAfterKeyword(text)
      case .detailsMissing(let keyword):
        self = .detailsMissing(keyword)
      }
    }

    case keywordMissing
    case invalidDeclarationKind(ParsedToken)
    case unexpectedTextAfterKeyword([ParsedToken])
    case detailsMissing(ParsedToken)
  }
}
