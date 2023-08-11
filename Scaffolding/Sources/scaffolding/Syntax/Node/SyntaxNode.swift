import SDGText

protocol SyntaxNode {
  var nodeKind: SyntaxNodeKind { get }
  var children: [SyntaxNode] { get }
  func source() -> StrictString
}

extension SyntaxNode {

  func source() -> StrictString {
    return children.lazy.map({ $0.source() }).joined()
  }

  func formattedGitStyleSource() -> StrictString {
    if self is SyntaxLeaf {
      return source()
    } else {
      return children.lazy.map({ $0.formattedGitStyleSource() }).joined()
    }
  }
}
