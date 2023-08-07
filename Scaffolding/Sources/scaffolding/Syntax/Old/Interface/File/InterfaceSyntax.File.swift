extension InterfaceSyntax {

  struct File {

    static func parse(source: UTF8Segments) -> Result<Self, Self.ParseError> {
      let tokens = OldParsedToken.tokenize(source: source)
      switch ParsedSeparatedList<Declaration, OldParsedToken>.parse(
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

    let declarations: ParsedSeparatedList<Declaration, OldParsedToken>
  }
}

extension InterfaceSyntax.File: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [declarations]
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
