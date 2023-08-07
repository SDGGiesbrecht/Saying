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
      case .nestingError(let error):
        self = .nestingError(error)
      case .detailsMissing(let keyword):
        self = .detailsMissing(keyword)
      }
    }

    case keywordMissing
    case invalidDeclarationKind(OldParsedToken)
    case unexpectedTextAfterKeyword([OldParsedToken])
    case nestingError(ParsedNestingNodeParseError<Deferred>)
    case detailsMissing(UTF8Segments.Index)
    case thingParsingError(InterfaceSyntax.ThingDeclaration.ParseError)
  }
}
