struct ParsedSeparatedListContinuation<Entry, Separator>: ParsedSyntaxNode {

  let separator: Separator
  let entry: Entry
  let location: Slice<UTF8Segments>
}

