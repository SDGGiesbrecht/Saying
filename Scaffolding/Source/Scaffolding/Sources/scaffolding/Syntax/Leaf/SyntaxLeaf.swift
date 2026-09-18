import Saying

protocol SyntaxLeaf: SyntaxNodeProtocol {
  var leafKind: SyntaxLeafKind { get }
  var text: UnicodeText { get }
}

extension SyntaxLeaf { // SyntaxNodeProtocol
  func source() -> UnicodeText {
    return text
  }
}
