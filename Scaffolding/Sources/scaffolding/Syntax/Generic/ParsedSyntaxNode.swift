import SDGText

protocol ParsedSyntaxNode {

  var context: UTF8Segments { get }
  var startIndex: UTF8Segments.Index { get }
  var endIndex: UTF8Segments.Index { get }
  var location: Slice<UTF8Segments> { get }

  var children: [ParsedSyntaxNode] { get }
  func source() -> StrictString
}

extension ParsedSyntaxNode {

  func source() -> StrictString {
    return children.lazy.map({ $0.source() }).joined()
  }
}
