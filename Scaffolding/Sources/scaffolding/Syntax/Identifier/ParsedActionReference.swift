extension ParsedActionReference {

  func identifierSegments() -> [ParsedIdentifierSegment?] {
    var result: [ParsedIdentifierSegment?] = []
    result.append(initialIdentifierSegment)
    for continuation in arguments.continuations {
      result.append(continuation.identifierSegment)
    }
    result.append(finalIdentifierSegment)
    return result
  }

  func identifierText() -> UnicodeText {
    return UnicodeText(
      identifierSegments().lazy.map({ $0?.identifierText() ?? "" }).joined(separator: "()".unicodeScalars)
    )
  }
}
