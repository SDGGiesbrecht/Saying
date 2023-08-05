struct ParsedThingNameDeclaration {
  let openingParenthesis: ParsedToken
  let openingLineBreak: ParsedToken
  let names: ParsedSeparatedList<
    ParsedDictionaryEntry<
      ParsedUninterruptedIdentifier,
      ParsedUninterruptedIdentifier
    >,
    ParsedToken
  >
  let closingLineBreak: ParsedToken
  let closingParenthesis: ParsedToken
}

extension ParsedThingNameDeclaration: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [openingParenthesis, openingLineBreak, names, closingLineBreak, closingParenthesis]
  }
}

extension ParsedThingNameDeclaration: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return openingParenthesis
  }
  var lastChild: ParsedSyntaxNode {
    return closingParenthesis
  }
}

extension ParsedThingNameDeclaration {

  static func parse(
    source: ParsedSeparatedNestingGroup<Deferred, ParsedToken>
  ) -> Result<ParsedThingNameDeclaration, ParseError> {
    guard source.opening.tokens.count == 1,
      let opening = source.opening.tokens.first,
      opening.token.kind == .openingParenthesis,
      source.closing.tokens.count == 1,
      let closing = source.closing.tokens.first,
      closing.token.kind == .closingParenthesis else {
      fatalError("The thing name declaration parser was given something that is not a thing name declaration (which should never happen).")
    }

    typealias Expected = ParsedDictionaryEntry<
      ParsedUninterruptedIdentifier,
      ParsedUninterruptedIdentifier
    >
    switch source.contents.map({ Expected.parse(source: $0) }) {
    case .failure(let error):
      return .failure(.entryParseError(error))
    case .success(let names):
      return .success(
        ParsedThingNameDeclaration(
          openingParenthesis: opening,
          openingLineBreak: source.openingSeparator,
          names: names,
          closingLineBreak: source.closingSeparator,
          closingParenthesis: closing
        )
      )
    }
  }
}
