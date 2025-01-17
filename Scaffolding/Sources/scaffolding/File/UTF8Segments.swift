import SDGText

internal struct UTF8Segments {

  init(_ segments: [UTF8Segment]) {
    self.segments = segments
  }

  init(_ segment: StrictString) {
    self.segments = [UTF8Segment(offset: 0, source: segment)]
  }

  var segments: [UTF8Segment]

  func underlyingScalarOffset(of index: Index) -> Int {
    let segmentIndex = index.segment
    if let scalar = index.scalar {
      let segment = segments[segmentIndex]
      return segment.offset + segment.source[..<scalar].count
    } else if let lastSegment = segments.last {
      return lastSegment.offset + lastSegment.source.count
    } else {
      return 0
    }
  }
}

extension UTF8Segments: Collection {
  var startIndex: Index {
    return Index(segment: segments.startIndex, scalar: segments.first?.source.startIndex)
  }
  var endIndex: Index {
    return Index(segment: segments.endIndex, scalar: nil)
  }
  func index(after i: Index) -> Index {
    let segment = segments[i.segment]
    let nextIndex = segment.source.index(after: i.scalar!)
    if nextIndex == segment.source.endIndex {
      let nextSegment = segments.index(after: i.segment)
      return Index(
        segment: nextSegment,
        scalar: segments[nextSegment...].first?.source.startIndex
      )
    } else {
      return Index(segment: i.segment, scalar: nextIndex)
    }
  }
  subscript(position: Index) -> Unicode.Scalar {
    segments[position.segment].source[position.scalar!]
  }
}

extension UTF8Segments: BidirectionalCollection {

  func index(before i: Index) -> Index {
    guard let scalar = i.scalar else {
      return lastOfSegment(before: i.segment)
    }
    let segment = segments[i.segment].source
    if scalar == segment.startIndex {
      return lastOfSegment(before: i.segment)
    }
    return Index(segment: i.segment, scalar: segment.index(before: scalar))
  }

  private func lastOfSegment(before segmentIndex: Int) -> Index {
    let previousSegmentIndex = segments.indices[..<segmentIndex].last!
    let previousSegment = segments[previousSegmentIndex].source
    return Index(
      segment: previousSegmentIndex,
      scalar: previousSegment.index(before: previousSegment.endIndex)
    )
  }
}
