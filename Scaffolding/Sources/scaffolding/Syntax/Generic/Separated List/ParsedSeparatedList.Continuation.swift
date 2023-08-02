struct ParsedSeparatedListContinuation<Entry, Separator>: ParsedSyntaxNode
where Separator: ParsedSyntaxNode, Entry: ParsedSyntaxNode {
  let separator: Separator
  let entry: Entry
}

extension ParsedSeparatedListContinuation: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return separator
  }
  var lastChild: ParsedSyntaxNode {
    return entry
  }
}
