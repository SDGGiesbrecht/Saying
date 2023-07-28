extension InterfaceSyntax.ThingDeclaration {

  enum ParseError: InterfaceSyntaxDeclarationParseErrorProtocol {

    case keywordMissing
    case notAThing

    static var mismatchedKeyword: Self {
      return .notAThing
    }
  }
}
