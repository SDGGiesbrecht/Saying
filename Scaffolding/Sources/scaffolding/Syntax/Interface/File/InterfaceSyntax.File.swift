extension InterfaceSyntax {

  struct File {

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

extension InterfaceSyntax.File: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    return [declarations]
  }
}

extension InterfaceSyntax.File: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return declarations
  }
  var lastChild: ManualParsedSyntaxNode {
    return declarations
  }
}
