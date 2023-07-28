extension InterfaceSyntax.ActionDeclaration {

  enum ParseError: InterfaceSyntaxDeclarationParseErrorProtocol {

    case commonParseError(InterfaceSyntax.Declaration.CommonParseError)
  }
}
