extension InterfaceSyntax {

  struct Declaration: ParsedSyntaxNode {
    let kind: Kind
    let location: Slice<UTF8Segments>
  }
}

extension InterfaceSyntax.Declaration: ParsedSeparatedListEntry {

  static func parse(
    source: [ParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<Self, Self.ParseError> {

    switch InterfaceSyntax.ThingDeclaration.parse(source: source, location: location) {
    case .success(let thing):
      return .success(InterfaceSyntax.Declaration(kind: .thing(thing), location: thing.location))
    case .failure(let error):
      switch error {
      case .keywordMissing:
        return .failure(.keywordMissing)
      case .notAThing:
        break
      }
    }

    switch InterfaceSyntax.ActionDeclaration.parse(source: source, location: location) {
    case .success(let action):
      return .success(InterfaceSyntax.Declaration(kind: .action(action), location: location))
    case .failure(let error):
      switch error {
      case .keywordMissing:
        return .failure(.keywordMissing)
      case .notAnAction:
        break
      }
    }

    return .failure(.invalidDeclarationKind(source.first!))
  }
}