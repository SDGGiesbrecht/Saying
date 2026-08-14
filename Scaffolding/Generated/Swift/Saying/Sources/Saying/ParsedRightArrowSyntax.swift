public struct ParsedRightArrowSyntax {
  public let location: SayingSourceSlice

  init(_ location: SayingSourceSlice) {
    self.location = location
  }

  public var type: ParsedSyntaxNodeType {
    return ParsedSyntaxNodeType.rightArrowSyntax(self)
  }
}
