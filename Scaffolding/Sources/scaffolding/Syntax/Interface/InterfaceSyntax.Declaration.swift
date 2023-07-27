extension InterfaceSyntax {

  struct Declaration: ParsedSyntaxNode {
    let tokens: [ParsedToken]
    let location: Slice<UTF8Segments>
  }
}

extension InterfaceSyntax.Declaration: ParsedSeparatedListEntry {

  static func parse(source: [ParsedToken], location: Slice<UTF8Segments>) -> Result<Self, Never> {
    return .success(InterfaceSyntax.Declaration(tokens: source, location: location))
  }
}
