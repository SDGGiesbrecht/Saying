extension UnicodeSegments {

  init(_ segments: [UnicodeSegment]) {
    self.init(segments: segments)
  }

  init(_ segment: UnicodeText) {
    self.init(segments: [UnicodeSegment(scalarOffset: 0, source: segment)])
  }
}

extension UnicodeSegments: BidirectionalCollection {}
