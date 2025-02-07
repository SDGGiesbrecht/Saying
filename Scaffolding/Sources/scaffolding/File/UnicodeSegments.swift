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
      return Int(segment.scalarOffset) + StrictString(segment.source)[..<scalar].count
    } else if let lastSegment = segmentIndices.last.map({ segment(at: ListIndex(index: $0)) }) {
      return Int(lastSegment.scalarOffset) + StrictString(lastSegment.source).count
    } else {
      return 0
    }
  }
}

extension UnicodeSegments: Collection {
  var startIndex: Index {
    return Index(
      segment: ListIndex(index: segmentIndices.startIndex),
      scalar: segmentIndices.first.map({ StrictString(segment(at: ListIndex(index: $0)).source).startIndex })
    )
  }
  var endIndex: Index {
    return Index(segment: ListIndex(index: segmentIndices.endIndex), scalar: nil)
  }
  func index(after i: Index) -> Index {
    let segment = segment(at: i.segmentIndex)
    let segmentSource = StrictString(segment.source)
    let nextIndex = segmentSource.index(after: i.scalarIndex!)
    if nextIndex == segmentSource.endIndex {
      let nextSegment = segmentIndices.index(after: i.segmentIndex.int)
      return Index(
        segment: ListIndex(index: nextSegment),
        scalar: segmentIndices[nextSegment...].first.map({ StrictString(self.segment(at: ListIndex(index: $0)).source).startIndex })
      )
    } else {
      return Index(segment: i.segmentIndex, scalar: nextIndex)
    }
  }
  subscript(position: Index) -> Unicode.Scalar {
    StrictString(segment(at: position.segmentIndex).source)[position.scalarIndex!]
  }
}

extension UnicodeSegments: BidirectionalCollection {

  func index(before i: Index) -> Index {
    guard let scalar = i.scalarIndex else {
      return lastOfSegment(before: i.segmentIndex.int)
    }
    let segment = StrictString(segment(at: i.segmentIndex).source)
    if scalar == segment.startIndex {
      return lastOfSegment(before: i.segmentIndex.int)
    }
    return Index(segment: i.segmentIndex, scalar: segment.index(before: scalar))
  }

  private func lastOfSegment(before segmentIndex: Int) -> Index {
    let previousSegmentIndex = segmentIndices[..<segmentIndex].last!
    let previousSegment = StrictString(segment(at: ListIndex(index: previousSegmentIndex)).source)
    return Index(
      segment: ListIndex(index: previousSegmentIndex),
      scalar: previousSegment.index(before: previousSegment.endIndex)
    )
  }
}
