extension Slice where Base == UnicodeSegments {

  func underlyingScalarOffsetOfStart() -> Int {
    return base.underlyingScalarOffset(of: startIndex)
  }
}
