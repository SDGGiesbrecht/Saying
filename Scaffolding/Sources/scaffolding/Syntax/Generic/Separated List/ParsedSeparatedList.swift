import SDGText

struct ParsedSeparatedList<Entry, Separator>: StoredLocation
where Entry: OldParsedSyntaxNode, Separator: OldParsedSyntaxNode {

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

extension ParsedSeparatedList: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    var result: [OldParsedSyntaxNode] = []
    if let entries = entries {
      result.append(entries)
    }
    return result
  }
}

extension ParsedSeparatedList {

  static func parse(
    source: [ParsedToken],
    location: Slice<UTF8Segments>,
    isSeparator: (ParsedToken) -> Bool
  ) -> Result<Self, Self.ParseError>
  where Entry: ParsedSeparatedListEntry, Separator == ParsedToken {
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

  func map<NewEntry, Error>(
    _ closure: (Entry) -> Result<NewEntry, Error>
  ) -> Result<ParsedSeparatedList<NewEntry, Separator>, Error> {
    guard let entries = self.entries else {
      return .success(ParsedSeparatedList<NewEntry, Separator>(entries: nil, location: location))
    }
    switch entries.map(closure) {
    case .failure(let error):
      return .failure(error)
    case .success(let newEntries):
      return .success(
        ParsedSeparatedList<NewEntry, Separator>(entries: newEntries, location: location)
      )
    }
  }

  mutating func removeFirst() -> (entry: Entry, separator: Separator?)? {
    guard let entries = self.entries else {
      return nil
    }
    guard let firstContinuation = entries.continuations.first else {
      self = ParsedSeparatedList(
        entries: nil,
        location: context.emptySubSequence(at: self.location.endIndex)
      )
      return (entry: entries.first, separator: nil)
    }
    let newEntries = ParsedNonEmptySeparatedList(
      first: firstContinuation.entry,
      continuations: Array(entries.continuations.dropFirst())
    )
    self = ParsedSeparatedList(
      entries: newEntries,
      location: newEntries.location
    )
    return (entry: entries.first, separator: firstContinuation.separator)
  }

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
