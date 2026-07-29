import Saying

public protocol SyntaxLeaf: SyntaxNode {
  var leafKind: SyntaxLeafKind { get }
  var text: UnicodeText { get }
}

extension SyntaxLeaf { // SyntaxNode
  public func source() -> UnicodeText {
    return text
  }
}
