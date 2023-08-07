import SDGText

enum Tokenizer {

  static func source() -> StrictString {
    var result: [StrictString] = [
      "extension Tokenizer {",
      "",
      "  static func extractNext(from remainder: inout UTF8Segments.SubSequence) -> ParsedToken? {",
      "    guard let first = remainder.indices.first else {",
      "      return nil",
      "    }",
      "    switch remainder[first] {",
    ]
    for node in Node.nodes {
      switch node.kind {
      case .fixedLeaf(let scalar):
        result.append(contentsOf: [
          "    case \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22}:",
          "      let prefix = remainder.prefix(1)",
          "      remainder.removeFirst()",
          "      return Parsed\(node.name)(location: prefix)",
        ])
      case .variableLeaf:
        result.append(contentsOf: [
          "    case Parsed\(node.name).allowed:",
          "      var trailing = remainder[...].indices",
          "      trailing.removeFirst()",
          "      while let nextIndex = trailing.first,",
          "        Parsed\(node.name).allowed.contains(remainder[nextIndex]) {",
          "          trailing.removeFirst()",
          "      }",
          "      let location = remainder[..<trailing.startIndex]",
          "      remainder = remainder[location.endIndex...]",
          "      return Parsed\(node.name)(location: location)",
        ])
      case .compound:
        break
      case .errorToken:
        result.append(contentsOf: [
          "    default:",
          "      let prefix = remainder.prefix(1)",
          "      remainder.removeFirst()",
          "      return ParsedErrorToken(location: prefix)",
        ])
      }
    }
    /*while let index = remainder.indices.first {
      let scalar = source[index]
      let slice: Slice<UTF8Segments>
      let token: ParsedToken
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
    }*/
    result.append(contentsOf: [
      "    }",
      "  }",
      "}",
    ])
    return result.joined(separator: "\n")
  }
}
