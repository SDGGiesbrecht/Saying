import SDGText

protocol SyntaxNode {
  var nodeKind: SyntaxNodeKind { get }
  var children: [SyntaxNode] { get }
  func source() -> StrictString

  func parsedNode() -> ParsedSyntaxNode
}

extension SyntaxNode {

  func source() -> StrictString {
    return children.lazy.map({ $0.source() }).joined()
  }

  func formattedGitStyleSource() -> StrictString {
    switch nodeKind {
    case .paragraphBreak:
      return "\n\n"
    case .lineBreak:
      return "\n"
    default:
      if self is ParsedSyntaxLeaf {
        return source()
      } else {
        return children.lazy.map({ $0.formattedGitStyleSource() }).joined()
      }
    }
  }
}
