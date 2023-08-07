import SDGText

struct ParsedUninterruptedIdentifier {
  let components: ParsedNonEmptySeparatedList<OldParsedToken, OldParsedToken>
}

extension ParsedUninterruptedIdentifier: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [components]
  }
}

extension ParsedUninterruptedIdentifier: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return components
  }
  var lastChild: ParsedSyntaxNode {
    return components
  }
}

extension ParsedUninterruptedIdentifier {
  var text: StrictString {
    return source()
  }
}

extension ParsedUninterruptedIdentifier: ParsedDictionaryTerm, ParsedDictionaryDefinition {

  static func parse(
    source: [OldParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<ParsedUninterruptedIdentifier, ParseError> {
    switch ParsedNonEmptySeparatedList<OldParsedToken, OldParsedToken>.parse(
      source: source,
      location: location,
      isSeparator: { $0.token.kind == .space }
    ) {
    case .failure(let error):
      switch error {
      case .empty:
        return.failure(.missingToken(location.startIndex))
      case .brokenEntry(let error):
        switch error {
        case .none(let index):
          let spaceBefore = location[..<index].suffix(1)
          let spaceAfter = location[index...].dropFirst().prefix(1)
          let spaceToken = Token(source: " ", kind: .space)!
          if spaceBefore.isEmpty {
            return .failure(.initialSpace(OldParsedToken(token: spaceToken, location: spaceAfter)))
          } else if spaceAfter.isEmpty {
            return .failure(.finalSpace(OldParsedToken(token: spaceToken, location: spaceBefore)))
          } else {
            return .failure(.consecutiveSpaces([
              OldParsedToken(token: spaceToken, location: spaceBefore),
              OldParsedToken(token: spaceToken, location: spaceAfter),
            ]))
          }
        case .multipleTokens:
          fatalError("The identifier parser was given something that is not an identifier (which should never happen)")
        }
      }
    case .success(let components):
      return .success(ParsedUninterruptedIdentifier(components: components))
    }
  }
}
