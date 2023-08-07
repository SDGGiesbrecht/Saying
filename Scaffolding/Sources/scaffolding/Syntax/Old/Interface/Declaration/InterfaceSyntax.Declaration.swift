import SDGText

extension InterfaceSyntax {

  enum Declaration: ParsedSyntaxNode {
    case thing(InterfaceSyntax.ThingDeclaration)
    case action(InterfaceSyntax.ActionDeclaration)
  }
}

extension InterfaceSyntax.Declaration: AlternateForms {
  var form: ParsedSyntaxNode {
    switch self {
    case .thing(let thing):
      return thing
    case .action(let action):
      return action
    }
  }
}

extension InterfaceSyntax.Declaration: ParsedSeparatedListEntry {

  static func parse(
    source: [OldParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<Self, Self.ParseError> {
    switch ParsedSeparatedList<Deferred, OldParsedToken>.parse(
      source: source,
      location: location,
      isSeparator: { $0.token.kind == .lineBreak }
    ) {
    case .failure(let error):
      fatalError("Line breaking failed (which should never happen): \(error)")
    case .success(let lines):

      switch InterfaceSyntax.ThingDeclaration.parse(lines: lines) {
      case .success(let thing):
        return .success(.thing(thing))
      case .failure(let error):
        switch error {
        case .common(let error):
          switch error {
          case .keywordMissing, .unexpectedTextAfterKeyword, .detailsMissing, .nestingError:
            return .failure(ParseError(error)!)
          case .mismatchedKeyword:
            break
          }
        case .unique(let error):
          return .failure(.thingParsingError(.unique(error)))
        }
      }

      switch InterfaceSyntax.ActionDeclaration.parse(lines: lines) {
      case .success(let action):
        return .success(.action(action))
      case .failure(let error):
        switch error {
        case .common(let error):
          switch error {
          case .keywordMissing, .unexpectedTextAfterKeyword, .detailsMissing, .nestingError:
            return .failure(ParseError(error)!)
          case .mismatchedKeyword:
            break
          }
        }
      }

      return .failure(.invalidDeclarationKind(source.first!))
    }
  }
}
