public struct ParsedLineBreakSyntax {
  public let location: SayingSourceSlice

  init(_ location: SayingSourceSlice) {
    self.location = location
  }

  public var children: [ParsedSyntaxNode] {
    return []
  }
}
