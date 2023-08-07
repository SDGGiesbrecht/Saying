extension InterfaceSyntax.ThingDeclaration {

  enum ParseError: InterfaceSyntaxDeclarationParseErrorProtocol {

    case common(InterfaceSyntax.Declaration.CommonParseError)
    case unique(InterfaceSyntax.ThingDeclaration.UniqueParseError)
  }
}
