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
    case .reference(let reference):
      var result: [ParsedIdentifierSegment?] = []
      result.append(reference.initialIdentifierSegment)
      for continuation in reference.arguments.continuations {
        result.append(continuation.identifierSegment)
      }
      result.append(reference.finalIdentifierSegment)
      return result
    case .literal:
      return []
    }
  }

  func name() -> UnicodeText {
    return UnicodeText(
      identifierSegments().lazy.map({ ($0?.identifierText()).map({ StrictString($0) }) ?? "" }).joined(separator: "()")
    )
  }
}
