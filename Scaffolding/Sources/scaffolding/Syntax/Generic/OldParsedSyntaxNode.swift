import SDGText

#warning("Remove.")
protocol ManualParsedSyntaxNode {

  var context: UTF8Segments { get }
  var startIndex: UTF8Segments.Index { get }
  var endIndex: UTF8Segments.Index { get }
  var location: Slice<UTF8Segments> { get }

  var children: [ManualParsedSyntaxNode] { get }
  func source() -> StrictString
}

extension ManualParsedSyntaxNode {

  func source() -> StrictString {
    return children.lazy.map({ $0.source() }).joined()
  }
}
