public struct UnicodeSegments {
  let segments: [Unicode_0020segment]

  init(_ segments: [Unicode_0020segment]) {
    self.segments = segments
  }

  public init(allOf text: UnicodeText) {
    var segments: [Unicode_0020segment] = []
    segments.append(Unicode_0020segment(.arithmeticZero, text))
    self = UnicodeSegments(segments)
  }

  public func formIndex(after i: inout UnicodeSegments.Boundary) {
    i = self.index(after: i)
  }

  public func index(after i: UnicodeSegments.Boundary) -> UnicodeSegments.Boundary {
    let segment_0020list: [Unicode_0020segment] = self.segments
    let segment_0020cursor: Int = i.beginning_0020of_0020segment
    let segment: UnicodeText = segment_0020list[segment_0020cursor].source
    if let scalar_0020cursor = i.scalar {
      let next_0020scalar: String.UnicodeScalarView.Index = segment.index(after: scalar_0020cursor)
      if next_0020scalar == segment.endIndex {
        let next_0020segment_0020cursor: Int = segment_0020list.index(after: segment_0020cursor)
        if next_0020segment_0020cursor == segment_0020list.endIndex {
          return UnicodeSegments.Boundary(next_0020segment_0020cursor, nil)
        }
        return UnicodeSegments.Boundary(next_0020segment_0020cursor, segment_0020list[next_0020segment_0020cursor].source.startIndex)
      }
      return UnicodeSegments.Boundary(segment_0020cursor, next_0020scalar)
    }
    fatalError()
  }

  public func index(before i: UnicodeSegments.Boundary) -> UnicodeSegments.Boundary {
    let segment_0020cursor: Int = i.beginning_0020of_0020segment
    if let scalar_0020cursor = i.scalar {
      let segment_0020list: [Unicode_0020segment] = self.segments
      let segment: UnicodeText = segment_0020list[segment_0020cursor].source
      if scalar_0020cursor == segment.startIndex {
        return before_0020end_0020of_0020segment_0020before_0020_0028_0029_0020in_0020_0028_0029_002C_0020skipping_0020bounds_0020check_003Alist_0020boundary_003AUnicode_0020segments_003AUnicode_0020segments_0020boundary(segment_0020cursor, self)
      }
      return UnicodeSegments.Boundary(segment_0020cursor, segment.boundary(beforeBoundary: scalar_0020cursor))
    }
    return before_0020end_0020of_0020segment_0020before_0020_0028_0029_0020in_0020_0028_0029_002C_0020skipping_0020bounds_0020check_003Alist_0020boundary_003AUnicode_0020segments_003AUnicode_0020segments_0020boundary(segment_0020cursor, self)
  }

  public var endIndex: UnicodeSegments.Boundary {
    return UnicodeSegments.Boundary(self.segments.endIndex, nil)
  }

  public subscript(accordingToDefaultUseAsList position: UnicodeSegments.Boundary) -> Unicode.Scalar {
    return self[entryIndex: self.indexSkippingBoundsCheck(afterBoundary: position)]
  }

  public subscript(_ position: UnicodeSegments.Boundary) -> Unicode.Scalar {
    return self[accordingToDefaultUseAsList: position]
  }

  public subscript(entryIndex index: UnicodeSegments.EntryIndex) -> Unicode.Scalar {
    return self.segments[index.segment].source[entryIndex: index.scalar]
  }

  public func indexSkippingBoundsCheck(afterBoundary boundary: UnicodeSegments.Boundary) -> UnicodeSegments.EntryIndex {
    if let scalar_0020boundary = boundary.scalar {
      let segment_0020list: [Unicode_0020segment] = self.segments
      let segment_0020index: Int = boundary.beginning_0020of_0020segment
      return UnicodeSegments.EntryIndex(segment_0020index, segment_0020list[segment_0020index].source.indexSkippingBoundsCheck(afterBoundary: scalar_0020boundary))
    }
    fatalError()
  }

  public func underlyingScalarOffset(of boundary: UnicodeSegments.Boundary) -> UInt64 {
    if let scalar_0020boundary = boundary.scalar {
      let segment: Unicode_0020segment = segments_0020of_0020_0028_0029_003AUnicode_0020segments_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029(self)[boundary.beginning_0020of_0020segment]
      let segment_0020source: UnicodeText = segment.source
      return segment.scalar_0020offset + UInt64(segment_0020source.offset(from: segment_0020source.startIndex, to: scalar_0020boundary))
    }
    if let last_0020segment = segments_0020of_0020_0028_0029_003AUnicode_0020segments_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029(self).last {
      return last_0020segment.scalar_0020offset + last_0020segment.source.numberOfEntries()
    }
    return .arithmeticZero
  }

  public var startIndex: UnicodeSegments.Boundary {
    let segment_0020list: [Unicode_0020segment] = self.segments
    let segment_0020cursor: Int = segment_0020list.startIndex
    if let first_0020segment = segment_0020list.first {
      return UnicodeSegments.Boundary(segment_0020cursor, first_0020segment.source.startIndex)
    }
    return UnicodeSegments.Boundary(segment_0020cursor, nil)
  }
}

func segments_0020of_0020_0028_0029_003AUnicode_0020segments_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029(_ instance: UnicodeSegments) -> [Unicode_0020segment] {
  return instance.segments
}
