extension UnicodeSegments {
  public struct EntryIndex {
    let segment: Int
    let scalar: String.UnicodeScalarView.Index

    init(_ segment: Int, _ scalar: String.UnicodeScalarView.Index) {
      self.segment = segment
      self.scalar = scalar
    }
  }
}
