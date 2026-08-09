extension UnicodeSegments {
  public struct Boundary {
    let beginning_0020of_0020segment: Int
    let scalar: String.UnicodeScalarView.Index?

    init(_ beginning_0020of_0020segment: Int, _ scalar: String.UnicodeScalarView.Index?) {
      self.beginning_0020of_0020segment = beginning_0020of_0020segment
      self.scalar = scalar
    }
  }
}

public func ==(_ lhs: UnicodeSegments.Boundary, _ rhs: UnicodeSegments.Boundary) -> Bool {
  return lhs.beginning_0020of_0020segment == rhs.beginning_0020of_0020segment && lhs.scalar == rhs.scalar
}

public func <(_ lhs: UnicodeSegments.Boundary, _ rhs: UnicodeSegments.Boundary) -> Bool {
  if let result = compare(lhs.beginning_0020of_0020segment, to: rhs.beginning_0020of_0020segment) {
    return result
  }
  if let first_0020scalar = lhs.scalar {
    if let second_0020scalar = rhs.scalar {
      return first_0020scalar < second_0020scalar
    }
    return true
  }
  return false
}
