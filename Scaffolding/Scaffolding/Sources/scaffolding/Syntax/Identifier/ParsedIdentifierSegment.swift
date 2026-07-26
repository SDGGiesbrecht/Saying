protocol IdentifierSegment: SyntaxNode {
  var identifierSegmentKind: IdentifierSegmentKind { get }
}

extension IdentifierSegment {

  func identifierText() -> UnicodeText {
    return source()
  }
}
