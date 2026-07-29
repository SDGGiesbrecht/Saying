import Saying

public protocol ParsedSyntaxNode {
  var nodeKind: ParsedSyntaxNodeKind { get }
  var children: [ParsedSyntaxNode] { get }

  var context: UnicodeSegments { get }
  var startIndex: UnicodeSegments.Index { get }
  var endIndex: UnicodeSegments.Index { get }
  var location: SayingSourceSlice { get }

  func mutableNode() -> SyntaxNode
}

extension ParsedSyntaxNode {

  public func source() -> UnicodeText {
    switch location.code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return UnicodeText(unicode)
    }
  }
}
