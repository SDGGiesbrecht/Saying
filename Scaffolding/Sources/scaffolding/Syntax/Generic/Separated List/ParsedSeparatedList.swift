import SDGText

struct ParsedSeparatedList<Entry, Separator>: ParsedSyntaxNode
where Entry: ParsedSyntaxNode, Separator: ParsedSyntaxNode {

  init(
    entries: ParsedNonEmptySeparatedList<Entry, Separator>?,
    location: Slice<UTF8Segments>
  ) {
    self.entries = entries
    self.location = location
  }

  let entries: ParsedNonEmptySeparatedList<Entry, Separator>?
  let location: Slice<UTF8Segments>

  var combinedEntries: [Entry] {
    return entries?.combinedEntries ?? []
  }
}

extension ParsedSeparatedList where Entry: ParsedSeparatedListEntry, Separator == ParsedToken {

  static func parse(
    source: [ParsedToken],
    location: Slice<UTF8Segments>,
    isSeparator: (ParsedToken) -> Bool
  ) -> Result<Self, Self.ParseError> {
    switch ParsedNonEmptySeparatedList<Entry, Separator>.parse(
      source: source,
      location: location,
      isSeparator: isSeparator
    ) {
    case .failure(let error):
      switch error {
      case .empty:
        return .success(ParsedSeparatedList(entries: nil, location: location))
      case .brokenEntry(let error):
        return .failure(.brokenEntry(error))
      }
    case .success(let nonEmpty):
      return .success(ParsedSeparatedList(entries: nonEmpty, location: location))
    }
  }
}

extension ParsedSeparatedList {

  func processNesting(
    isOpening: (Entry) -> Bool,
    isClosing: (Entry) -> Bool
  ) -> Result<
    ParsedSeparatedList<ParsedSeparatedNestingNode<Entry, Separator>, Separator>,
    ParsedNestingNodeParseError<Entry>
  > {
    guard let entries = self.entries else {
      return .success(
        ParsedSeparatedList<ParsedSeparatedNestingNode<Entry, Separator>, Separator>(
          entries: nil,
          location: location
        )
      )
    }
    switch entries.processNesting(isOpening: isOpening, isClosing: isClosing) {
    case .failure(let error):
      return .failure(error)
    case .success(let converted):
      return .success(
        ParsedSeparatedList<ParsedSeparatedNestingNode<Entry, Separator>, Separator>(
          entries: converted,
          location: location
        )
      )
    }
  }
}
