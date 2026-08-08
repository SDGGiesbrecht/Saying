public struct UnicodeText {
  var scalars: String.UnicodeScalarView

  public init(skippingNormalizationOf scalars: String.UnicodeScalarView) {
    self.scalars = scalars
  }

  public var isEmpty: Bool {
    return self.scalars.isEmpty
  }

  public func replacingAccordingToDefaultSearchingAndReplacing(_ pattern: UnicodeText, with replacement: UnicodeText) -> UnicodeText {
    var cursor: String.UnicodeScalarView.Index = self.startIndex
    var changed: UnicodeText = .empty
    for hit in self.matches(of: pattern) {
      let match: Slice<UnicodeText> = hit.contents
      changed.append(contentsOf: Slice(base: self, bounds: cursor ..< match.startIndex))
      changed.append(contentsOf: replacement)
      cursor = match.endIndex
    }
    changed.append(contentsOf: Slice(base: self, bounds: cursor ..< self.endIndex))
    return changed
  }

  public func replacing(_ pattern: UnicodeText, with replacement: UnicodeText) -> UnicodeText {
    return self.replacingAccordingToDefaultSearchingAndReplacing(pattern, with: replacement)
  }

  public init(_ scalars: String.UnicodeScalarView) {
    self = UnicodeText(skippingNormalizationOf: scalars.compatibilityDecomposition())
  }

  public func formIndex(after i: inout String.UnicodeScalarView.Index) {
    self.scalars.formIndex(after: &i)
  }

  public mutating func appendAccordingToDefaultListInsertion(contentsOf newElements: Slice<UnicodeText>) {
    self.replaceSubrange(self.endIndex ..< self.endIndex, with: newElements)
  }

  public mutating func append(contentsOf newElements: Slice<UnicodeText>) {
    self.appendAccordingToDefaultListInsertion(contentsOf: newElements)
  }

  public mutating func append(contentsOf newElements: UnicodeText) {
    if let next = newElements.first {
      if let previous = self.last {
        let next_0020class: Unicode.CanonicalCombiningClass = next.combiningClass
        if next_0020class == .notReordered || previous.combiningClass <= next_0020class {
          self.scalars += newElements.scalars
        } else {
          var seam_0020start: String.UnicodeScalarView.Index = self.endIndex
          while (scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(seam_0020start, self)) {
            self.formIndex(before: &seam_0020start)
          }
          let seam_0020overlap: Range<String.UnicodeScalarView.Index> = seam_0020start ..< self.endIndex
          var seam: String.UnicodeScalarView = String.UnicodeScalarView(Slice(base: self.scalars, bounds: seam_0020overlap))
          self.removeSubrange(seam_0020overlap)
          var seam_0020end: String.UnicodeScalarView.Index = newElements.startIndex
          while (scalar_0020after_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(seam_0020end, newElements)) {
            newElements.formIndex(after: &seam_0020end)
          }
          seam.append(contentsOf: Slice(base: newElements.scalars, bounds: newElements.startIndex ..< seam_0020end))
          seam.reorderCanonically()
          self.scalars += seam
          self.scalars.append(contentsOf: Slice(base: newElements.scalars, bounds: seam_0020end ..< newElements.endIndex))
        }
        return
      }
      self = newElements
    }
  }

  public func formIndex(before i: inout String.UnicodeScalarView.Index) {
    self.scalars.formIndex(before: &i)
  }

  public func index(after i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.scalars.index(after: i)
  }

  public func index(before i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.scalars.index(before: i)
  }

  public func boundary(beforeBoundary cursor: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if cursor > self.startIndex {
      return self.index(before: cursor)
    }
    return nil
  }

  public init(_ other: Slice<UnicodeText>) {
    self = UnicodeText(skippingNormalizationOf: String.UnicodeScalarView(Slice(base: other.base.scalars, bounds: { let slice = other; return slice.startIndex ..< slice.endIndex }())))
  }

  public init(_ other: UnicodeText) {
    self = other
  }

  public var endIndex: String.UnicodeScalarView.Index {
    return self.scalars.endIndex
  }

  public subscript(_ position: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.scalars[position]
  }

  public subscript(entryIndex index: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.scalars[index]
  }

  public var first: Unicode.Scalar? {
    return self.scalars.first
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.scalars)
  }

  public func indexSkippingBoundsCheck(afterBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return boundary
  }

  public func entryIndex(afterBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if boundary < self.endIndex {
      return self.indexSkippingBoundsCheck(afterBoundary: boundary)
    }
    return nil
  }

  public func indexSkippingBoundsCheck(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.indexSkippingBoundsCheck(afterBoundary: self.index(before: boundary))
  }

  public func entryIndex(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if boundary > self.startIndex {
      return self.indexSkippingBoundsCheck(beforeBoundary: boundary)
    }
    return nil
  }

  public var last: Unicode.Scalar? {
    return self.scalars.last
  }

  public func matches(of pattern: UnicodeText) -> [Slice<UnicodeText>] {
    var cursor: String.UnicodeScalarView.Index = self.startIndex
    let end: String.UnicodeScalarView.Index = self.endIndex
    var matches: [Slice<UnicodeText>] = []
    while let match = (Slice(base: self, bounds: cursor ..< end).firstMatch(of: pattern)) {
      cursor = match.contents.endIndex
      matches.append(match)
    }
    return matches
  }

  public func numberOfEntries() -> UInt64 {
    return self.scalars.numberOfEntries()
  }

  public func offset(from origin: String.UnicodeScalarView.Index, to destination: String.UnicodeScalarView.Index) -> Int64 {
    return self.scalars.offset(from: origin, to: destination)
  }

  public var count: Int {
    return self.scalars.count
  }

  public func distance(from start: String.UnicodeScalarView.Index, to end: String.UnicodeScalarView.Index) -> Int {
    return self.scalars.distance(from: start, to: end)
  }

  public mutating func prependAccordingToDefaultListInsertion(contentsOf newElements: UnicodeText) {
    self.replaceSubrange(self.startIndex ..< self.startIndex, with: newElements)
  }

  public mutating func prepend(contentsOf newElements: UnicodeText) {
    self.prependAccordingToDefaultListInsertion(contentsOf: newElements)
  }

  public func primaryMatch(beginningAt beginning: String.UnicodeScalarView.Index, in haystack: Slice<UnicodeText>) -> Slice<UnicodeText>? {
    return primary_0020match_0020for_0020_0028_0029_0020beginning_0020at_0020_0028_0029_0020in_0020_0028_0029_0020according_0020to_0020use_0020as_0020literal_0020pattern_003AUnicodeText_003AUnicode_0020scalar_0020boundary_003A_0028_003Aslice_0020of_0020_0028_0029_003AUnicodeText_003A_0029_003A_0028_003Aoptional_0020_0028_0029_003A_0028_003Aslice_0020of_0020_0028_0029_003AUnicodeText_003A_0029_003A_0029(self, beginning, haystack)
  }

  public mutating func removeSubrangeAccordingToListInsertion(_ bounds: Range<String.UnicodeScalarView.Index>) {
    self.replaceSubrange(bounds, with: .empty)
  }

  public mutating func removeSubrange(_ bounds: Range<String.UnicodeScalarView.Index>) {
    self.removeSubrangeAccordingToListInsertion(bounds)
  }

  public mutating func replaceSubrange(_ subrange: Range<String.UnicodeScalarView.Index>, with newElements: Slice<UnicodeText>) {
    self.replaceSubrange(subrange, with: UnicodeText(newElements))
  }

  public mutating func replaceSubrange(_ subrange: Range<String.UnicodeScalarView.Index>, with newElements: UnicodeText) {
    let end: String.UnicodeScalarView.Index = self.endIndex
    let after: UnicodeText = UnicodeText(Slice(base: self, bounds: subrange.upperBound ..< end))
    self.scalars.removeSubrange(subrange.lowerBound ..< end)
    self.append(contentsOf: newElements)
    self.append(contentsOf: after)
  }

  public mutating func replaceAccordingToDefaultSearchingAndReplacing(_ pattern: UnicodeText, with replacement: UnicodeText) {
    self = self.replacing(pattern, with: replacement)
  }

  public mutating func replace(_ pattern: UnicodeText, with replacement: UnicodeText) {
    self.replaceAccordingToDefaultSearchingAndReplacing(pattern, with: replacement)
  }

  public var startIndex: String.UnicodeScalarView.Index {
    return self.scalars.startIndex
  }

  public init(_ slice: Slice<UnicodeSegments>) {
    let segments_0020of_0020whole: [Unicode_0020segment] = slice.base.segments
    var cursor: UnicodeSegments.Boundary = slice.startIndex
    let end: UnicodeSegments.Boundary = slice.endIndex
    let segment_0020of_0020end: Int = end.beginning_0020of_0020segment
    var text: UnicodeText = .empty
    while (cursor < end) {
      let segment_0020of_0020cursor: Int = cursor.beginning_0020of_0020segment
      let segment: UnicodeText = segments_0020of_0020whole[segment_0020of_0020cursor].source
      if let beginning = cursor.scalar {
        if segment_0020of_0020cursor < segment_0020of_0020end {
          text.append(contentsOf: Slice(base: segment, bounds: beginning ..< segment.endIndex))
        } else {
          if let scalar_0020of_0020end = end.scalar {
            text.append(contentsOf: Slice(base: segment, bounds: beginning ..< scalar_0020of_0020end))
          }
        }
        let next_0020segment: Int = segments_0020of_0020whole.index(after: segment_0020of_0020cursor)
        if let next_0020index = segments_0020of_0020whole.entryIndex(afterBoundary: next_0020segment) {
          cursor = UnicodeSegments.Boundary(next_0020segment, segments_0020of_0020whole[next_0020index].source.startIndex)
        } else {
          cursor = UnicodeSegments.Boundary(next_0020segment, nil)
        }
      }
    }
    self = text
  }
}

public func ==(_ lhs: UnicodeText, _ rhs: UnicodeText) -> Bool {
  return lhs.scalars == rhs.scalars
}

extension UnicodeText {
  public static var empty: UnicodeText {
    return UnicodeText(skippingNormalizationOf: "".unicodeScalars)
  }
}

func primary_0020match_0020for_0020_0028_0029_0020beginning_0020at_0020_0028_0029_0020in_0020_0028_0029_0020according_0020to_0020use_0020as_0020literal_0020pattern_003AUnicodeText_003AUnicode_0020scalar_0020boundary_003A_0028_003Aslice_0020of_0020_0028_0029_003AUnicodeText_003A_0029_003A_0028_003Aoptional_0020_0028_0029_003A_0028_003Aslice_0020of_0020_0028_0029_003AUnicodeText_003A_0029_003A_0029(_ pattern: UnicodeText, _ beginning: String.UnicodeScalarView.Index, _ haystack: Slice<UnicodeText>) -> Slice<UnicodeText>? {
  var cursor_0020in_0020pattern: String.UnicodeScalarView.Index = pattern.startIndex
  let end_0020of_0020pattern: String.UnicodeScalarView.Index = pattern.endIndex
  var cursor_0020in_0020haystack: String.UnicodeScalarView.Index = beginning
  let end_0020of_0020haystack: String.UnicodeScalarView.Index = haystack.endIndex
  while (cursor_0020in_0020pattern < end_0020of_0020pattern) {
    if cursor_0020in_0020haystack >= end_0020of_0020haystack {
      return nil
    }
    if pattern[entryIndex: pattern.indexSkippingBoundsCheck(afterBoundary: cursor_0020in_0020pattern)] != haystack[entryIndex: haystack.indexSkippingBoundsCheck(afterBoundary: cursor_0020in_0020haystack)] {
      return nil
    }
    pattern.formIndex(after: &cursor_0020in_0020pattern)
    haystack.formIndex(after: &cursor_0020in_0020haystack)
  }
  return Slice(base: haystack.base, bounds: beginning ..< cursor_0020in_0020haystack)
}
