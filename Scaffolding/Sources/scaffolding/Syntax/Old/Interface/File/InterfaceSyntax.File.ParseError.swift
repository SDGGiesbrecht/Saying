extension InterfaceSyntax.File {

  enum ParseError: Error {
    case brokenDeclarationList(
      ParsedSeparatedList<InterfaceSyntax.Declaration, OldParsedToken>.ParseError
    )
  }
}
