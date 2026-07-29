import Saying

public protocol ParsedIdentifierSegment: ParsedSyntaxNode {
  var identifierSegmentKind: ParsedIdentifierSegmentKind { get }
}
