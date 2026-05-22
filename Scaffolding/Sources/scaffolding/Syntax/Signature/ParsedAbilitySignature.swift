extension ParsedAbilitySignature {

  func identifierSegments() -> [ParsedIdentifierSegment?] {
    var result: [ParsedIdentifierSegment?] = []
    result.append(initialIdentifierSegment)
    for continuation in parameters.continuations {
      result.append(continuation.identifierSegment)
    }
    result.append(finalIdentifierSegment)
    return result
  }

  func name() -> UnicodeText {
    return identifierSegments().map({ $0?.identifierText() ?? "" }).joined(separator: "()")
  }
}
