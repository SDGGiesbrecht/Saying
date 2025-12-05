extension Signature {

  func identifierSegments() -> [IdentifierSegment?] {
    switch self {
    case .simple(let simple):
      return [simple]
    case .compound(let compound):
      var result: [IdentifierSegment?] = []
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
      identifierSegments().lazy.map({ $0?.identifierText() ?? "" }).joined(separator: "()".unicodeScalars)
    )
  }
}
