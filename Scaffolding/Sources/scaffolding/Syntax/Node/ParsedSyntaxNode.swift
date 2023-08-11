import SDGText

protocol ParsedSyntaxNode {
  var nodeKind: ParsedSyntaxNodeKind { get }
  var children: [ParsedSyntaxNode] { get }

  var context: UTF8Segments { get }
  var startIndex: UTF8Segments.Index { get }
  var endIndex: UTF8Segments.Index { get }
  var location: Slice<UTF8Segments> { get }
}

extension ParsedSyntaxNode {

  func source() -> StrictString {
    return StrictString(location)
  }

  func formattedGitStyleSource() -> StrictString {
    if self is ParsedSyntaxLeaf {
      return source()
    } else {
      return children.lazy.map({ $0.formattedGitStyleSource() }).joined()
    }
  }
}
