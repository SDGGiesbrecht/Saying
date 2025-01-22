import SDGText

extension UnicodeSegments {

  init(_ segments: [UnicodeSegment]) {
    self.init(segments: segments)
  }

  init(_ segment: UnicodeText) {
    self.init(segments: [UnicodeSegment(scalarOffset: 0, source: segment)])
  }

  func underlyingScalarOffset(of index: Index) -> Int {
    let segmentIndex = index.segment
    if let scalar = index.scalar {
      let segment = segment(at: segmentIndex)
      return Int(segment.scalarOffset) + StrictString(segment.source)[..<scalar].count
    } else if let lastSegment = segmentIndices.last.map({ segment(at: $0) }) {
      return Int(lastSegment.scalarOffset) + StrictString(lastSegment.source).count
    } else {
      return 0
    }
  }
}

extension UnicodeSegments: Collection {
  var startIndex: Index {
    return Index(
      segment: segmentIndices.startIndex,
      scalar: segmentIndices.first.map({ StrictString(segment(at: $0).source).startIndex })
    )
  }
  var endIndex: Index {
    return Index(segment: segmentIndices.endIndex, scalar: nil)
  }
  func index(after i: Index) -> Index {
    let segment = segment(at: i.segment)
    let segmentSource = StrictString(segment.source)
    let nextIndex = segmentSource.index(after: i.scalar!)
    if nextIndex == segmentSource.endIndex {
      let nextSegment = segmentIndices.index(after: i.segment)
      return Index(
        segment: nextSegment,
        scalar: segmentIndices[nextSegment...].first.map({ StrictString(self.segment(at: $0).source).startIndex })
      )
    } else {
      return Index(segment: i.segment, scalar: nextIndex)
    }
  }
  subscript(position: Index) -> Unicode.Scalar {
    StrictString(segment(at: position.segment).source)[position.scalar!]
  }
}

extension UnicodeSegments: BidirectionalCollection {

  func index(before i: Index) -> Index {
    guard let scalar = i.scalar else {
      return lastOfSegment(before: i.segment)
    }
    let segment = StrictString(segment(at: i.segment).source)
    if scalar == segment.startIndex {
      return lastOfSegment(before: i.segment)
    }
    return Index(segment: i.segment, scalar: segment.index(before: scalar))
  }

  private func lastOfSegment(before segmentIndex: Int) -> Index {
    let previousSegmentIndex = segmentIndices[..<segmentIndex].last!
    let previousSegment = StrictString(segment(at: previousSegmentIndex).source)
    return Index(
      segment: previousSegmentIndex,
      scalar: previousSegment.index(before: previousSegment.endIndex)
    )
  }
}
