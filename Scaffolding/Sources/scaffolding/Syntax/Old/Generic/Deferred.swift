struct Deferred: StoredLocation {
  let tokens: [OldParsedToken]
  let location: Slice<UTF8Segments>
}

extension Deferred: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return tokens
  }
}

extension Deferred: ParsedSeparatedListEntry {

  static func parse(source: [OldParsedToken], location: Slice<UTF8Segments>) -> Result<Deferred, Never> {
    return .success(Deferred(tokens: source, location: location))
  }
}
