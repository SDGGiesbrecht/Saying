protocol InterfaceSyntaxDeclarationParseErrorProtocol: Error {
  static var keywordMissing: Self { get }
  static var mismatchedKeyword: Self { get }
}
