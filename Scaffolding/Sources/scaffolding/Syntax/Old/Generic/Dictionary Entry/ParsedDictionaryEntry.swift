struct ParsedDictionaryEntry<Term, Definition>
where Term: ParsedSyntaxNode, Definition: ParsedSyntaxNode {
  let term: Term
  let colon: ParsedSpacedColon
  let definition: Definition
}

extension ParsedDictionaryEntry: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [term, colon, definition]
  }
}

extension ParsedDictionaryEntry: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return term
  }
  var lastChild: ParsedSyntaxNode {
    return definition
  }
}

extension ParsedDictionaryEntry {

  static func parse(source: Deferred) -> Result<ParsedDictionaryEntry, ParseError>
  where Term: ParsedDictionaryTerm, Definition: ParsedDictionaryDefinition {
    guard let colonIndex = source.tokens.firstIndex(where: { $0.token.kind == .colon }) else {
      return .failure(.missingDefinition(source.endIndex))
    }
    var termTokens = source.tokens[..<colonIndex]
    let colon = source.tokens[colonIndex]
    var definitionTokens = source.tokens[colonIndex...].dropFirst()

    var leadingSpace: OldParsedToken?
    if termTokens.last?.token.kind == .space {
      leadingSpace = termTokens.removeLast()
    }

    guard definitionTokens.first?.token.kind == .space else {
      return .failure(.colonNotFollowedBySpace(colon.endIndex))
    }
    let trailingSpace = definitionTokens.removeFirst()

    let colonNode = ParsedSpacedColon(
      leadingSpace: leadingSpace?.asSpace,
      colon: colon.asColon!,
      trailingSpace: trailingSpace.asSpace!
    )

    let termTokenArray = Array(termTokens)
    let definitionTokenArray = Array(definitionTokens)
    switch Term.parse(
      source: termTokenArray,
      location: termTokenArray.location()
        ?? colon.context.emptySubSequence(at: leadingSpace?.startIndex ?? colon.startIndex)
    ) {
    case .failure(let error):
      return .failure(.termParseError(error))
    case .success(let term):
      switch Definition.parse(
        source: definitionTokenArray,
        location: definitionTokenArray.location()
          ?? trailingSpace.context.emptySubSequence(at: trailingSpace.endIndex)
      ) {
      case .failure(let error):
        return .failure(.definitionParseError(error))
      case .success(let definition):
        return .success(
          ParsedDictionaryEntry(
            term: term,
            colon: colonNode,
            definition: definition
          )
        )
      }
    }
  }
}
