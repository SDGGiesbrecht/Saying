extension Slice<UnicodeText> {
  public var isNotEmptyAccordingToDefaultUseAsList: Bool {
    return !self.isEmpty
  }
}

extension Slice<UnicodeText> {
  public var isNotEmpty: Bool {
    return self.isNotEmptyAccordingToDefaultUseAsList
  }
}

extension Slice<UnicodeText> {
  public var contents: Slice<UnicodeText> {
    return self
  }
}

extension Slice<UnicodeText> {
  public subscript(entryIndex index: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.base[entryIndex: index]
  }
}

extension Slice<UnicodeText> {
  public func firstMatch(of pattern: UnicodeText) -> Slice<UnicodeText>? {
    var cursor: String.UnicodeScalarView.Index = self.startIndex
    let end: String.UnicodeScalarView.Index = self.endIndex
    while (cursor < end) {
      let result: Slice<UnicodeText>? = pattern.primaryMatch(beginningAt: cursor, in: self)
      if result != nil {
        return result
      }
      self.formIndex(after: &cursor)
    }
    return nil
  }
}

extension Slice<UnicodeText> {
  public func indexSkippingBoundsCheck(afterBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.base.indexSkippingBoundsCheck(afterBoundary: boundary)
  }
}
