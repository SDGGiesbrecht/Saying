extension InterfaceSyntax.Declaration {

  enum ParseError: Error {

    init?(_ error: InterfaceSyntax.Declaration.CommonParseError) {
      switch error {
      case .keywordMissing:
        self = .keywordMissing
      case .mismatchedKeyword:
        return nil
      case .noLineBreakAfterKeyword(let index):
        self = .noLineBreakAfterKeyword(index)
      }
    }

    case keywordMissing
    case invalidDeclarationKind(ParsedToken)
    case noLineBreakAfterKeyword(UTF8Segments.Index)
  }
}
