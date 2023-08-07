extension InterfaceSyntax.ActionDeclaration {

  enum ParseError: InterfaceSyntaxDeclarationParseErrorProtocol {

    case common(InterfaceSyntax.Declaration.CommonParseError)
  }
}
