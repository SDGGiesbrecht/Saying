struct Deferred: ParsedSyntaxNode, StoredLocation {
  let tokens: [ParsedToken]
  let location: Slice<UTF8Segments>
}

extension Deferred: ParsedSeparatedListEntry {

  static func parse(source: [ParsedToken], location: Slice<UTF8Segments>) -> Result<Deferred, Never> {
    return .success(Deferred(tokens: source, location: location))
  }
}
