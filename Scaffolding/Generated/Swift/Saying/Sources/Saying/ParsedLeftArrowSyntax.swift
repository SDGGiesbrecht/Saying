public struct ParsedLeftArrowSyntax {
  public let location: SayingSourceSlice

  init(_ location: SayingSourceSlice) {
    self.location = location
  }

  public var type: ParsedSyntaxNodeType {
    return ParsedSyntaxNodeType.leftArrowSyntax(self)
  }
}
