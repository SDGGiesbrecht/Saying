import SDGText

struct ParsedUninterruptedIdentifier {
  let components: ParsedNonEmptySeparatedList<ParsedToken, ParsedToken>
}

extension ParsedUninterruptedIdentifier: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    return [components]
  }
}

extension ParsedUninterruptedIdentifier: DerivedLocation {
  var firstChild: OldParsedSyntaxNode {
    return components
  }
  var lastChild: OldParsedSyntaxNode {
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
    source: [ParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<ParsedUninterruptedIdentifier, ParseError> {
    switch ParsedNonEmptySeparatedList<ParsedToken, ParsedToken>.parse(
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
            return .failure(.initialSpace(ParsedToken(token: spaceToken, location: spaceAfter)))
          } else if spaceAfter.isEmpty {
            return .failure(.finalSpace(ParsedToken(token: spaceToken, location: spaceBefore)))
          } else {
            return .failure(.consecutiveSpaces([
              ParsedToken(token: spaceToken, location: spaceBefore),
              ParsedToken(token: spaceToken, location: spaceAfter),
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
