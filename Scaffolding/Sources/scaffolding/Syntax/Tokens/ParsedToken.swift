import SDGText

struct ParsedToken {

  static func tokenize(source: UTF8Segments) -> Result<[ParsedToken], TokenizationError> {
    var parsed: [ParsedToken] = []
    var remainder = source[...]
    while let index = remainder.indices.first {
      let scalar = source[index]
      guard let kind = Token.Kind.kind(for: scalar) else {
        return .failure(.invalidScalar(scalar))
      }
      let slice: Slice<UTF8Segments>
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
      remainder = source[slice.endIndex...]
      let token = Token(source: StrictString(slice), kind: kind)!
      parsed.append(ParsedToken(token: token, location: slice))
    }
    return .success(parsed)
  }

  let token: Token
  let location: Slice<UTF8Segments>
}
