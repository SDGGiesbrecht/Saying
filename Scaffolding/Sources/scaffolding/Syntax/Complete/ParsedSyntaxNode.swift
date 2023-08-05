import SDGText

protocol ParsedSyntaxNode {
  var nodeKind: ParsedSyntaxNodeKind { get }
  var children: [SyntaxNode] { get }

  var context: UTF8Segments { get }
  var startIndex: UTF8Segments.Index { get }
  var endIndex: UTF8Segments.Index { get }
  var location: Slice<UTF8Segments> { get }
}

extension ParsedSyntaxNode {
  func source() -> StrictString {
    return StrictString(location)
  }
}
