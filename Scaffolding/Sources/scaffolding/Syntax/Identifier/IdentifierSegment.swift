protocol ParsedIdentifierSegment: ParsedSyntaxNode {
  var identifierSegmentKind: ParsedIdentifierSegmentKind { get }
}

extension ParsedIdentifierSegment {

  func identifierText() -> UnicodeText {
    return source()
  }
}
