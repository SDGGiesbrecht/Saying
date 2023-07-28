protocol InterfaceSyntaxDeclarationParseErrorProtocol: Error {
  static func commonParseError(_ error: InterfaceSyntax.Declaration.CommonParseError) -> Self
}
