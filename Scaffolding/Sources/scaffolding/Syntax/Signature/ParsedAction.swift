import SDGText

extension ParsedAction {

  func identifierSegments() -> [ParsedIdentifierSegment?] {
    switch self {
    case .simple(let simple):
      return [simple]
    case .compound(let compound):
      var result: [ParsedIdentifierSegment?] = []
      result.append(compound.initialIdentifierSegment)
      for continuation in compound.arguments.continuations {
        result.append(continuation.identifierSegment)
      }
      result.append(compound.finalIdentifierSegment)
      return result
    }
  }

  func name() -> StrictString {
    return identifierSegments().lazy.map({ $0?.identifierText() ?? "" }).joined(separator: "()")
  }
}
