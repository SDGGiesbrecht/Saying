import SDGText

extension ParsedSignature {

  func identifierSegments() -> [ParsedIdentifierSegment?] {
    switch self {
    case .simple(let simple):
      return [simple]
    case .compound(let compound):
      var result: [ParsedIdentifierSegment?] = []
      result.append(compound.initialIdentifierSegment)
      for continuation in compound.parameters.continuations {
        result.append(continuation.identifierSegment)
      }
      result.append(compound.finalIdentifierSegment)
      return result
    }
  }

  func name() -> StrictString {
    return identifierSegments().lazy.map({ $0?.identifierText() ?? "" }).joined(separator: "()")
  }

  func parameters() -> [ParsedParameter] {
    switch self {
    case .compound(let compound):
      return compound.parameters.parameters
    case .simple:
      return []
    }
  }
}
