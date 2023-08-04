protocol InterfaceSyntaxDeclarationParseErrorProtocol: Error {
  static func common(_ error: InterfaceSyntax.Declaration.CommonParseError) -> Self
}
