import SDGText

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
    return UnicodeText(
      identifierSegments().lazy.map({ ($0?.identifierText()).map({ StrictString($0) }) ?? "" }).joined(separator: "()")
    )
  }
}
