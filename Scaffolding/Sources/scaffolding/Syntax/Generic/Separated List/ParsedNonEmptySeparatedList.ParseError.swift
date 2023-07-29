extension ParsedNonEmptySeparatedList where Entry: ParsedSeparatedListEntry {

  enum ParseError: Error {
    case empty
    case brokenEntry(Entry.ParseError)
  }
}
