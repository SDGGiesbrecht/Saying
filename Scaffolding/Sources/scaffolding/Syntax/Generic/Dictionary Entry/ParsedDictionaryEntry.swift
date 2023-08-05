struct ParsedDictionaryEntry<Term, Definition>
where Term: ManualParsedSyntaxNode, Definition: ManualParsedSyntaxNode {
  let term: Term
  let colon: ManualParsedColon
  let definition: Definition
}

extension ParsedDictionaryEntry: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    return [term, colon, definition]
  }
}

extension ParsedDictionaryEntry: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return term
  }
  var lastChild: ManualParsedSyntaxNode {
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

    var leadingSpace: ParsedToken?
    if termTokens.last?.token.kind == .space {
      leadingSpace = termTokens.removeLast()
    }

    guard definitionTokens.first?.token.kind == .space else {
      return .failure(.colonNotFollowedBySpace(colon.endIndex))
    }
    let trailingSpace = definitionTokens.removeFirst()

    let colonNode = ManualParsedColon(
      leadingSpace: leadingSpace,
      colon: colon,
      trailingSpace: trailingSpace
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
