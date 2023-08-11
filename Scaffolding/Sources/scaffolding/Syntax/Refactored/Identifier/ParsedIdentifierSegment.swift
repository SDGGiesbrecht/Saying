import SDGText

protocol IdentifierSegment: SyntaxNode {
  var identifierSegmentKind: IdentifierSegmentKind { get }
}

extension IdentifierSegment {

  func identifierText() -> StrictString {
    return source()
  }
}
