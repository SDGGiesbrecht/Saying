import SDGText

extension UnicodeSegments {

  init(_ segments: [UnicodeSegment]) {
    self.init(segments: segments)
  }

  init(_ segment: UnicodeText) {
    self.init(segments: [UnicodeSegment(scalarOffset: 0, source: segment)])
  }

  func underlyingScalarOffset(of index: Index) -> Int {
    let segmentIndex = index.segmentIndex
    if let scalar = index.scalarIndex {
      let segment = segment(at: segmentIndex)
      return Int(segment.scalarOffset) + segment.source[..<scalar].count
    } else if let lastSegment = segmentIndices.last.map({ segment(at: $0) }) {
      return Int(lastSegment.scalarOffset) + lastSegment.source.count
    } else {
      return 0
    }
  }
}

extension UnicodeSegments: Collection {
  var startIndex: Index {
    return Index(
      segment: segmentIndices.startIndex,
      scalar: segmentIndices.first.map({ segment(at: $0).source.startIndex })
    )
  }
  var endIndex: Index {
    return Index(segment: segmentIndices.endIndex, scalar: nil)
  }
  func index(after i: Index) -> Index {
    let segment = segment(at: i.segmentIndex)
    let nextIndex = segment.source.index(after: i.scalarIndex!)
    if nextIndex == segment.source.endIndex {
      let nextSegment = segmentIndices.index(after: i.segmentIndex)
      return Index(
        segment: nextSegment,
        scalar: segmentIndices[nextSegment...].first.map({ self.segment(at: $0).source.startIndex })
      )
    } else {
      return Index(segment: i.segmentIndex, scalar: nextIndex)
    }
  }
  subscript(position: Index) -> Unicode.Scalar {
    segment(at: position.segmentIndex).source[position.scalarIndex!]
  }
}

extension UnicodeSegments: BidirectionalCollection {

  func index(before i: Index) -> Index {
    guard let scalar = i.scalarIndex else {
      return lastOfSegment(before: i.segmentIndex)
    }
    let segment = StrictString(segment(at: i.segmentIndex).source)
    if scalar == segment.startIndex {
      return lastOfSegment(before: i.segmentIndex)
    }
    return Index(segment: i.segmentIndex, scalar: segment.index(before: scalar))
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
