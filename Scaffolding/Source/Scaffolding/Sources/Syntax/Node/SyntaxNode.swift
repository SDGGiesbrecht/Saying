import Saying

public protocol SyntaxNode {
  var nodeKind: SyntaxNodeKind { get }
  var children: [SyntaxNode] { get }
  func source() -> UnicodeText

  func parsedNode() -> ParsedSyntaxNode
}

extension SyntaxNode {

  public func source() -> UnicodeText {
    return children.map({ $0.source() }).joined()
  }
}
