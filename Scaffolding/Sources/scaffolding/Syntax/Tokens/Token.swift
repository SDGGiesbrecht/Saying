import SDGLogic
import SDGCollections
import SDGText

struct Token {

  static func tokenize(source: StrictString) -> Result<[Parsed<Token>], TokenizationError> {
    var parsed: [Parsed<Token>] = []
    var remainder = source[...]
    while let index = remainder.indices.first {
      let scalar = source[index]
      guard let kind = Kind.kind(for: scalar) else {
        return .failure(.invalidScalar(scalar))
      }
      let slice: Slice<StrictString>
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
      parsed.append(Parsed(node: token, location: slice))
    }
    return .success(parsed)
  }

  init?(source: StrictString, kind: Kind) {
    let allowed = kind.allowedCharacters
    guard source.allSatisfy({ allowed.contains($0) }),
      ¬kind.isSingleScalar ∨ source.count == 1 else {
      return nil
    }
    self.kind = kind
    self.source = source
  }

  let kind: Kind
  let source: StrictString
}
