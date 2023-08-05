extension Array where Element: OldParsedSyntaxNode {

  func location() -> Slice<UTF8Segments>? {
    if let first = self.first,
      let last = self.last {
      return first.location.base[first.location.startIndex..<last.location.endIndex]
    } else {
      return nil
    }
  }
}

extension Array where Element == OldParsedSyntaxNode {

  func location() -> Slice<UTF8Segments>? {
    if let first = self.first,
      let last = self.last {
      return first.location.base[first.location.startIndex..<last.location.endIndex]
    } else {
      return nil
    }
  }
}
