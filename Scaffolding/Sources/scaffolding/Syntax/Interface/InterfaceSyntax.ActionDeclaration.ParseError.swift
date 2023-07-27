extension InterfaceSyntax.ActionDeclaration {

  enum ParseError: Error {
    case keywordMissing
    case notAnAction
  }
}
