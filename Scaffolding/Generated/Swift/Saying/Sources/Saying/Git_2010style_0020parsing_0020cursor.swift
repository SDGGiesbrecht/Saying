struct Git_2010style_0020parsing_0020cursor {
  let cursor: String.UnicodeScalarView.Index
  let offset: UInt64

  init(_ cursor: String.UnicodeScalarView.Index, _ offset: UInt64) {
    self.cursor = cursor
    self.offset = offset
  }
}
