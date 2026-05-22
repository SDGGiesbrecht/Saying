extension ParsedModifiedImplementationParameter {

  func identifierSegments() -> [ParsedIdentifierSegment?] {
    var result: [ParsedIdentifierSegment?] = []
    result.append(initialModifierSegment)
    result.append(finalModifierSegment)
    return result
  }

  func identifierText() -> UnicodeText {
    return identifierSegments()
      .map({ $0?.identifierText() ?? "" })
      .joined(separator: "()")
  }
}
