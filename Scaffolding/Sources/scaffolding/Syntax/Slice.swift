extension Slice where Base == UTF8Segments {

  func underlyingScalarOffsetOfStart() -> Int {
    return base.underlyingScalarOffset(of: startIndex)
  }
}
