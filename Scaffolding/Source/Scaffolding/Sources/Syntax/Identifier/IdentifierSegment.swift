import Saying

public protocol IdentifierSegment: SyntaxNode {
  var identifierSegmentKind: IdentifierSegmentKind { get }
}
