extension ParsedSeparatedList {

  enum ParseError: Error {
    case brokenEntry(Entry.ParseError)
  }
}
