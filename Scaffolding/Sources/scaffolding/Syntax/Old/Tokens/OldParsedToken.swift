import SDGText

struct OldParsedToken: StoredLocation {

  static func tokenize(source: UTF8Segments) -> [OldParsedToken] {
    var parsed: [OldParsedToken] = []
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
      parsed.append(OldParsedToken(token: token, location: slice))
    }
    return parsed
  }

  let token: Token
  let location: Slice<UTF8Segments>
}

extension OldParsedToken: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return []
  }
  func source() -> StrictString {
    return token.source
  }
}

extension OldParsedToken: ParsedSeparatedListEntry {

  static func parse(
    source: [OldParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<OldParsedToken, ParseError> {
    guard let token = source.first else {
      return .failure(.none(location.startIndex))
    }
    guard source.count == 1 else {
      return .failure(.multipleTokens(source))
    }
    return .success(token)
  }
}

extension OldParsedToken {

  var asColon: ParsedColon? {
    switch token.kind {
    case .colon:
      return ParsedColon(location: location)
    default:
      return nil
    }
  }

  var asSpace: ParsedSpace? {
    switch token.kind {
    case .space:
      return ParsedSpace(location: location)
    default:
      return nil
    }
  }
}
