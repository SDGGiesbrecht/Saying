extension UnicodeSegments.Index: Comparable {
  static func < (lhs: UnicodeSegments.Index, rhs: UnicodeSegments.Index) -> Bool {
    guard let lhsScalar = lhs.scalarIndex else {
      return false
    }
    guard let rhsScalar = rhs.scalarIndex else {
      return true
    }
    return (lhs.segmentIndex.int, lhsScalar) < (rhs.segmentIndex.int, rhsScalar)
  }
}

extension UnicodeSegments.Index: Equatable {
  static func == (lhs: UnicodeSegments.Index, rhs: UnicodeSegments.Index) -> Bool {
    (lhs.segmentIndex.int, lhs.scalarIndex) == (rhs.segmentIndex.int, rhs.scalarIndex)
  }
}
