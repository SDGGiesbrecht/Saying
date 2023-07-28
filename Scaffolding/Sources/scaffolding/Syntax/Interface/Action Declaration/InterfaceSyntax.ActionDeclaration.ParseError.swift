extension InterfaceSyntax.ActionDeclaration {

  enum ParseError: InterfaceSyntaxDeclarationParseErrorProtocol {

    case keywordMissing
    case notAnAction

    static var mismatchedKeyword: Self {
      return .notAnAction
    }
  }
}
