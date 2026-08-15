public struct ParsedDownArrowSyntax {
  public let location: SayingSourceSlice

  init(_ location: SayingSourceSlice) {
    self.location = location
  }

  public var children: [ParsedSyntaxNodeType] {
    return []
  }

  public var type: ParsedSyntaxNodeType {
    return ParsedSyntaxNodeType.downArrowSyntax(self)
  }
}
