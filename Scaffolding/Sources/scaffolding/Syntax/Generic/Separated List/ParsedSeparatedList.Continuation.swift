struct ParsedSeparatedListContinuation<Entry, Separator>
where Separator: OldParsedSyntaxNode, Entry: OldParsedSyntaxNode {
  let separator: Separator
  let entry: Entry
}

extension ParsedSeparatedListContinuation: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    return [separator, entry]
  }
}

extension ParsedSeparatedListContinuation: DerivedLocation {
  var firstChild: OldParsedSyntaxNode {
    return separator
  }
  var lastChild: OldParsedSyntaxNode {
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
