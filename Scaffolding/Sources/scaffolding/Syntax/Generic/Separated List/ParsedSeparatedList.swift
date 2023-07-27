struct ParsedSeparatedList<Entry, Separator>: ParsedSyntaxNode
where Entry: ParsedSyntaxNode, Separator: ParsedSyntaxNode,
  Entry: ParsedSeparatedListEntry {

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

extension ParsedSeparatedList where Separator == ParsedToken {

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
