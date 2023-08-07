import SDGText

protocol ParsedSyntaxNode {
  var nodeKind: ParsedSyntaxNodeKind { get }
  var children: [ParsedSyntaxNode] { get }

  var context: UTF8Segments { get }
  var startIndex: UTF8Segments.Index { get }
  var endIndex: UTF8Segments.Index { get }
  var location: Slice<UTF8Segments> { get }
}

extension ParsedSyntaxNode {

  #warning("This is temporary to allow use by deprecated nodes.")
  var nodeKind: ParsedSyntaxNodeKind {
    fatalError("\(Self.self) has no node kind.")
  }
  
  func source() -> StrictString {
    return StrictString(location)
  }
}
