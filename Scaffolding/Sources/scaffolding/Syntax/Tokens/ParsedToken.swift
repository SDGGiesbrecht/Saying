import SDGText

struct ParsedToken: StoredLocation {

  static func tokenize(source: UTF8Segments) -> [ParsedToken] {
    var parsed: [ParsedToken] = []
    var remainder = source[...]
    while let index = remainder.indices.first {
      let scalar = source[index]
      let slice: Slice<UTF8Segments>
      let token: Token
      if let kind = Token.Kind.kind(for: scalar) {
        if kind.isSingleScalar {
          slice = source[index ..< source.index(after: index)]
        } else {
          let allowed = kind.allowedCharacters
          var trailing = remainder[index...].indices
          trailing.removeFirst()
          while let nextIndex = trailing.first,
                allowed.contains(source[nextIndex]) {
            trailing.removeFirst()
          }
          slice = source[index ..< trailing.startIndex]
        }
        token = Token(source: StrictString(slice), kind: kind)!
      } else {
        slice = source[index ..< source.index(after: index)]
        token = Token(error: scalar)
      }
      remainder = source[slice.endIndex...]
      parsed.append(ParsedToken(token: token, location: slice))
    }
    return parsed
  }

  let token: Token
  let location: Slice<UTF8Segments>
}

extension ParsedToken: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    return []
  }
  func source() -> StrictString {
    return token.source
  }
}

extension ParsedToken: ParsedSeparatedListEntry {

  static func parse(
    source: [ParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<ParsedToken, ParseError> {
    guard let token = source.first else {
      return .failure(.none(location.startIndex))
    }
    guard source.count == 1 else {
      return .failure(.multipleTokens(source))
    }
    return .success(token)
  }
}
