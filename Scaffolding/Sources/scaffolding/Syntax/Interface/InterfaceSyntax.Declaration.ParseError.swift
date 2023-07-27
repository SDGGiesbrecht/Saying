extension InterfaceSyntax.Declaration {

  enum ParseError: Error {
    case keywordMissing
    case invalidDeclarationKind(ParsedToken)
  }
}
