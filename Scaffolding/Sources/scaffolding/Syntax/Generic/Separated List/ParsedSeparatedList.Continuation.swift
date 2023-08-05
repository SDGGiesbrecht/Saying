struct ParsedSeparatedListContinuation<Entry, Separator>
where Separator: ManualParsedSyntaxNode, Entry: ManualParsedSyntaxNode {
  let separator: Separator
  let entry: Entry
}

extension ParsedSeparatedListContinuation: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    return [separator, entry]
  }
}

extension ParsedSeparatedListContinuation: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return separator
  }
  var lastChild: ManualParsedSyntaxNode {
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
