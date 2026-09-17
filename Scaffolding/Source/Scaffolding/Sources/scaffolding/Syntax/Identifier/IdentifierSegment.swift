import Saying

protocol ParsedIdentifierSegment: ParsedSyntaxNodeProtocol {
  var identifierSegmentKind: ParsedIdentifierSegmentKind { get }
}

extension ParsedIdentifierSegment {

  func identifierText() -> UnicodeText {
    return source()
  }
}
