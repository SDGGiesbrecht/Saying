public struct GitStyleSayingSource {
  public let origin: UnicodeText
  public let code: UnicodeText

  public init(origin: UnicodeText, code: UnicodeText) {
    self.origin = origin
    self.code = code
  }

  public func parsed() -> SayingSource {
    let code: UnicodeText = self.code
    var beginning_0020of_0020segment: Git_2010style_0020parsing_0020cursor? = nil
    var segments: [Unicode_0020segment] = []
    let indices: UnicodeText.Indices = code.indices
    let last_0020index: String.UnicodeScalarView.Index? = indices.last
    var offset_0020cursor1: UInt64 = .arithmeticZero
    for index in indices {
      let offset: UInt64 = offset_0020cursor1
      offset_0020cursor1.increment()
      let scalar: Unicode.Scalar = code[entryIndex: index]
      if scalar == "\u{A}" as Unicode.Scalar {
        parse_0020line_0020in_0020_0028_0029_0020from_0020_0028_0029_0020to_0020_0028_0029_0020into_0020_0028_0029_003AGitStyleSayingSource_003A_0028_003Aoptional_0020_0028_0029_003AGit_2010style_0020parsing_0020cursor_003A_0029_003AUnicode_0020scalar_0020boundary_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029_003A(self, &beginning_0020of_0020segment, index, &segments)
        if index != last_0020index {
          var combined: Bool = false
          if let preceding_0020segment = segments.last {
            if source_0020of_0020_0028_0029_003AUnicode_0020segment_003AUnicodeText(preceding_0020segment) == UnicodeText(skippingNormalizationOf: "\u{2028}".unicodeScalars) {
              segments.removeLast()
              segments.append(Unicode_0020segment(preceding_0020segment.scalar_0020offset, UnicodeText(skippingNormalizationOf: "\u{2029}".unicodeScalars)))
              combined = true
            }
          }
          if !combined {
            segments.append(Unicode_0020segment(offset, UnicodeText(skippingNormalizationOf: "\u{2028}".unicodeScalars)))
          }
        }
      } else {
        if beginning_0020of_0020segment == nil {
          beginning_0020of_0020segment = Git_2010style_0020parsing_0020cursor(index, offset)
        }
        if index == last_0020index {
          parse_0020line_0020in_0020_0028_0029_0020from_0020_0028_0029_0020to_0020_0028_0029_0020into_0020_0028_0029_003AGitStyleSayingSource_003A_0028_003Aoptional_0020_0028_0029_003AGit_2010style_0020parsing_0020cursor_003A_0029_003AUnicode_0020scalar_0020boundary_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029_003A(self, &beginning_0020of_0020segment, code.endIndex, &segments)
        }
      }
    }
    return SayingSource(origin: self.origin, code: SayingSourceCode.utf8(UnicodeSegments(segments)))
  }
}
