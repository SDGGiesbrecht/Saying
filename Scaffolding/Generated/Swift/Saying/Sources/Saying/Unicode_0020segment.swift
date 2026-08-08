struct Unicode_0020segment {
  let scalar_0020offset: UInt64
  let source: UnicodeText

  init(_ scalar_0020offset: UInt64, _ source: UnicodeText) {
    self.scalar_0020offset = scalar_0020offset
    self.source = source
  }
}

func source_0020of_0020_0028_0029_003AUnicode_0020segment_003AUnicodeText(_ segment: Unicode_0020segment) -> UnicodeText {
  return segment.source
}
