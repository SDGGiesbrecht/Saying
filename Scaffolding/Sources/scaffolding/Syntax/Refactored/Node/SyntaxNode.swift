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
}
