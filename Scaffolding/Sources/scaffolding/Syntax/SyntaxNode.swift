import SDGText

protocol SyntaxNode {
  var children: [SyntaxNode] { get }
  func source() -> StrictString
}

extension SyntaxNode {
  func source() -> StrictString {
    return children.lazy.map({ $0.source() }).joined()
  }
}
