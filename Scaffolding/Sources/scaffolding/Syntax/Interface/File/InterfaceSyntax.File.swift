extension InterfaceSyntax {

  struct File: ParsedSyntaxNode {

    static func parse(source: UTF8Segments) -> Result<Self, Self.ParseError> {
      let tokens = ParsedToken.tokenize(source: source)
      switch ParsedSeparatedList<Declaration, ParsedToken>.parse(
        source: tokens,
        location: tokens.location() ?? source.emptySubSequence(at: source.startIndex),
        isSeparator: { $0.token.kind == .paragraphBreak }
      ) {
      case .failure(let error):
        return .failure(.brokenDeclarationList(error))
      case .success(let declarations):
        return .success(File(declarations: declarations))
      }
    }

    let declarations: ParsedSeparatedList<Declaration, ParsedToken>
  }
}

extension InterfaceSyntax.File: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return declarations
  }
  var lastChild: ParsedSyntaxNode {
    return declarations
  }
}
