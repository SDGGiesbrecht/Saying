import Saying

protocol IdentifierSegment: SyntaxNodeProtocol {
  var identifierSegmentKind: IdentifierSegmentKind { get }
}

extension IdentifierSegment {

  func identifierText() -> UnicodeText {
    return source()
  }
}
