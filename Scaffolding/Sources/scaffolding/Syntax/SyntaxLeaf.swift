import SDGText

protocol SyntaxLeaf: SyntaxNode {
  var text: StrictString { get }
}

extension SyntaxLeaf { // SyntaxNode
  func source() -> StrictString {
    return text
  }
}
