import SDGText

extension UnicodeSegments {
  struct Index {
    let segment: Array<UnicodeSegment>.Index
    let scalar: StrictString.Index?
  }
}

extension UnicodeSegments.Index: Comparable {
  static func < (lhs: UnicodeSegments.Index, rhs: UnicodeSegments.Index) -> Bool {
    guard let lhsScalar = lhs.scalar else {
      return false
    }
    guard let rhsScalar = rhs.scalar else {
      return true
    }
    return (lhs.segment, lhsScalar) < (rhs.segment, rhsScalar)
  }
}
