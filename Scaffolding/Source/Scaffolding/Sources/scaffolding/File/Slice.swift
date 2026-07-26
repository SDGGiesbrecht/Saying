extension Slice where Base == UnicodeSegments {

  func underlyingScalarOffsetOfStart() -> UInt64 {
    return base.underlyingScalarOffset(of: startIndex)
  }
}
