import SDGText

internal struct UTF8Segments {

  init(_ segments: [UnicodeSegment]) {
    self.segments = segments
  }

  init(_ segment: UnicodeText) {
    self.segments = [UnicodeSegment(scalarOffset: 0, source: segment)]
  }

  var segments: [UnicodeSegment]

  func underlyingScalarOffset(of index: Index) -> Int {
    let segmentIndex = index.segment
    if let scalar = index.scalar {
      let segment = segments[segmentIndex]
      return Int(segment.scalarOffset) + StrictString(segment.source)[..<scalar].count
    } else if let lastSegment = segments.last {
      return Int(lastSegment.scalarOffset) + StrictString(lastSegment.source).count
    } else {
      return 0
    }
  }
}

extension UTF8Segments: Collection {
  var startIndex: Index {
    return Index(segment: segments.startIndex, scalar: (segments.first?.source).map({ StrictString($0) })?.startIndex)
  }
  var endIndex: Index {
    return Index(segment: segments.endIndex, scalar: nil)
  }
  func index(after i: Index) -> Index {
    let segment = segments[i.segment]
    let segmentSource = StrictString(segment.source)
    let nextIndex = segmentSource.index(after: i.scalar!)
    if nextIndex == segmentSource.endIndex {
      let nextSegment = segments.index(after: i.segment)
      return Index(
        segment: nextSegment,
        scalar: (segments[nextSegment...].first?.source).map({ StrictString($0) })?.startIndex
      )
    } else {
      return Index(segment: i.segment, scalar: nextIndex)
    }
  }
  subscript(position: Index) -> Unicode.Scalar {
    StrictString(segments[position.segment].source)[position.scalar!]
  }
}

extension UTF8Segments: BidirectionalCollection {

  func index(before i: Index) -> Index {
    guard let scalar = i.scalar else {
      return lastOfSegment(before: i.segment)
    }
    let segment = StrictString(segments[i.segment].source)
    if scalar == segment.startIndex {
      return lastOfSegment(before: i.segment)
    }
    return Index(segment: i.segment, scalar: segment.index(before: scalar))
  }

  private func lastOfSegment(before segmentIndex: Int) -> Index {
    let previousSegmentIndex = segments.indices[..<segmentIndex].last!
    let previousSegment = StrictString(segments[previousSegmentIndex].source)
    return Index(
      segment: previousSegmentIndex,
      scalar: previousSegment.index(before: previousSegment.endIndex)
    )
  }
}
