import SDGText

extension Action {

  func identifierSegments() -> [IdentifierSegment?] {
    switch self {
    case .new(let new):
      #warning("Not implemented yet.")
      return []
    case .simple(let simple):
      return [simple]
    case .compound(let compound):
      var result: [IdentifierSegment?] = []
      result.append(compound.initialIdentifierSegment)
      for continuation in compound.arguments.continuations {
        result.append(continuation.identifierSegment)
      }
      result.append(compound.finalIdentifierSegment)
      return result
    case .reference(let reference):
      var result: [IdentifierSegment?] = []
      result.append(reference.initialIdentifierSegment)
      for continuation in reference.arguments.continuations {
        result.append(continuation.identifierSegment)
      }
      result.append(reference.finalIdentifierSegment)
      return result
    }
  }

  func name() -> StrictString {
    return identifierSegments().lazy.map({ $0?.identifierText() ?? "" }).joined(separator: "()")
  }
}
