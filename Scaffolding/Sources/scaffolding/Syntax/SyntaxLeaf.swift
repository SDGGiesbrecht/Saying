import SDGText

protocol SyntaxLeaf: SyntaxNode {
  var leafKind: SyntaxLeafKind { get }
  var text: StrictString { get }
}

extension SyntaxLeaf { // SyntaxNode
  func source() -> StrictString {
    return text
  }
}
