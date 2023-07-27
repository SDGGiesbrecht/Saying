extension ParsedNonEmptySeparatedList {

  enum ParseError: Error {
    case empty
    case brokenEntry(Entry.ParseError)
  }
}
