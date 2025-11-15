import SDGText

extension ParsedModifiedImplementationParameter {
  
  func identifierSegments() -> [ParsedIdentifierSegment?] {
    var result: [ParsedIdentifierSegment?] = []
    result.append(initialModifierSegment)
    result.append(finalModifierSegment)
    return result
  }

  func identifierText() -> UnicodeText {
    return UnicodeText(
      identifierSegments()
        .lazy.map({ ($0?.identifierText()).map({ StrictString($0) }) ?? "" })
        .joined(separator: "()")
    )
  }
}
