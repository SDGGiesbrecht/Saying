import SDGText

extension ParsedParameterName {

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

  func name() -> UnicodeText {
    return UnicodeText(
      identifierSegments().lazy.map({ ($0?.identifierText()).map({ StrictString($0 )}) ?? "" }).joined(separator: "()")
    )
  }
}
