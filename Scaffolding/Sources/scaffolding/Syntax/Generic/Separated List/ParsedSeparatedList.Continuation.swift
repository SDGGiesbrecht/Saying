struct ParsedSeparatedListContinuation<Entry, Separator> {

  let separator: Separator
  let entry: Entry
  let location: Slice<UTF8Segments>
}

