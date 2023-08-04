struct ParsedThingNameDeclaration: ParsedSyntaxNode {
  let openingParenthesis: ParsedToken
  let openingLineBreak: ParsedToken
  let names: ParsedSeparatedList<Deferred, ParsedToken>
  let closingLineBreak: ParsedToken
  let closingParenthesis: ParsedToken
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

    return .success(
      ParsedThingNameDeclaration(
        openingParenthesis: opening,
        openingLineBreak: source.openingSeparator,
        names: source.contents,
        closingLineBreak: source.closingSeparator,
        closingParenthesis: closing
      )
    )
  }
}
