extension ParsedSeparatedList where Entry: ParsedSeparatedListEntry {

  enum ParseError: Error {
    case brokenEntry(Entry.ParseError)
  }
}
