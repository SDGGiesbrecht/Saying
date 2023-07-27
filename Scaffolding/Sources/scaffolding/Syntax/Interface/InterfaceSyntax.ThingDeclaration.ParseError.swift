extension InterfaceSyntax.ThingDeclaration {

  enum ParseError: Error {
    case keywordMissing
    case notAThing
  }
}
