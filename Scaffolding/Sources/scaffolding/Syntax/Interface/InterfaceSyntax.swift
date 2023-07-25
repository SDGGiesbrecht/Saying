enum InterfaceSyntax {

  static func parse(source: UTF8Segments) -> File {
    let tokens = ParsedToken.tokenize(source: source)
    let location: Slice<UTF8Segments>
    if let first = tokens.first,
      let last = tokens.last {
      location = source[first.location.startIndex..<last.location.endIndex]
    } else {
      location = source[source.startIndex..<source.startIndex]
    }
    return File(tokens: tokens, location: location)
  }
}
