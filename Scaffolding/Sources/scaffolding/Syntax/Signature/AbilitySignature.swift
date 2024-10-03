import SDGText

extension AbilitySignature {

  func identifierSegments() -> [IdentifierSegment?] {
    var result: [IdentifierSegment?] = []
    result.append(initialIdentifierSegment)
    for continuation in parameters.continuations {
      result.append(continuation.identifierSegment)
    }
    result.append(finalIdentifierSegment)
    return result
  }

  func name() -> StrictString {
    return identifierSegments().lazy.map({ $0?.identifierText() ?? "" }).joined(separator: "()")
  }
}
