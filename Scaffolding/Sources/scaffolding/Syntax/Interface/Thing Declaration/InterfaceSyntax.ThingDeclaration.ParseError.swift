extension InterfaceSyntax.ThingDeclaration {

  enum ParseError: InterfaceSyntaxDeclarationParseErrorProtocol {

    case commonParseError(InterfaceSyntax.Declaration.CommonParseError)
  }
}
