import SDGText

protocol ParsedIdentifierSegment: ParsedSyntaxNode {
  var identifierSegmentKind: ParsedIdentifierSegmentKind { get }
}

extension ParsedIdentifierSegment {

  func identifierText() -> StrictString {
    return source()
  }
}
