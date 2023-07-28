extension InterfaceSyntax {

  struct File: ParsedSyntaxNode {

    static func parse(source: UTF8Segments) -> Result<Self, Self.ParseError> {
      let tokens = ParsedToken.tokenize(source: source)
      let location = tokens.location() ?? source.emptySubSequence(at: source.startIndex)
      switch ParsedSeparatedList<Declaration, ParsedToken>.parse(
        source: tokens,
        location: location,
        isSeparator: { $0.token.kind == .paragraphBreak }
      ) {
      case .failure(let error):
        return .failure(.brokenDeclarationList(error))
      case .success(let declarations):
        return .success(File(declarations: declarations, location: location))
      }
    }

    let declarations: ParsedSeparatedList<Declaration, ParsedToken>
    let location: Slice<UTF8Segments>
  }
}
