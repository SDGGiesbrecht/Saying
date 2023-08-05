protocol DerivedLocation: ParsedSyntaxNode {
  var firstChild: ParsedSyntaxNode { get }
  var lastChild: ParsedSyntaxNode { get }
}

extension DerivedLocation {
  var location: Slice<UTF8Segments> {
    return context[startIndex..<endIndex]
  }
  var context: UTF8Segments {
    return firstChild.context
  }
  var startIndex: UTF8Segments.Index {
    return firstChild.startIndex
  }
  var endIndex: UTF8Segments.Index {
    return lastChild.endIndex
  }
}
