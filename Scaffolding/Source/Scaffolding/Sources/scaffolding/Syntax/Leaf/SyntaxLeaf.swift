protocol SyntaxLeaf: SyntaxNode {
  var leafKind: SyntaxLeafKind { get }
  var text: UnicodeText { get }
}

extension SyntaxLeaf { // SyntaxNode
  func source() -> UnicodeText {
    return text
  }
}
