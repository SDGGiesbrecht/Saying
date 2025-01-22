import SDGText

extension UTF8Segments {
  struct Index {
    let segment: Array<UnicodeSegment>.Index
    let scalar: StrictString.Index?
  }
}

extension UTF8Segments.Index: Comparable {
  static func < (lhs: UTF8Segments.Index, rhs: UTF8Segments.Index) -> Bool {
    guard let lhsScalar = lhs.scalar else {
      return false
    }
    guard let rhsScalar = rhs.scalar else {
      return true
    }
    return (lhs.segment, lhsScalar) < (rhs.segment, rhsScalar)
  }
}
