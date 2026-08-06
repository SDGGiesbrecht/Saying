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
