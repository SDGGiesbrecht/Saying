struct ParsedSeparatedListContinuation<Entry, Separator>
where Separator: ParsedSyntaxNode, Entry: ParsedSyntaxNode {
  let separator: Separator
  let entry: Entry
}

extension ParsedSeparatedListContinuation: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [separator, entry]
  }
}

extension ParsedSeparatedListContinuation: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return separator
  }
  var lastChild: ParsedSyntaxNode {
    return entry
  }
}

extension ParsedSeparatedListContinuation {

  func map<NewEntry, Error>(
    _ closure: (Entry) -> Result<NewEntry, Error>
  ) -> Result<ParsedSeparatedListContinuation<NewEntry, Separator>, Error> {
    switch closure(entry) {
    case .failure(let error):
      return .failure(error)
    case .success(let newEntry):
      return .success(
        ParsedSeparatedListContinuation<NewEntry, Separator>(separator: separator, entry: newEntry)
      )
    }
  }
}
