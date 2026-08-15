public struct ParsedParagraphBreakSyntax {
  public let location: SayingSourceSlice

  init(_ location: SayingSourceSlice) {
    self.location = location
  }

  public var children: [ParsedSyntaxNodeType] {
    return []
  }

  public var type: ParsedSyntaxNodeType {
    return ParsedSyntaxNodeType.paragraphBreakSyntax(self)
  }
}
