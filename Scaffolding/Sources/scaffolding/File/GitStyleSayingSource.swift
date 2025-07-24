import Foundation

import SDGText
import SDGPersistence

extension GitStyleSayingSource {

  init(from url: URL) throws {
    self.init(origin: UnicodeText(url.path), code: UnicodeText(try String(from: url)))
  }

  private func registerSegment(
    in segments: inout [UnicodeSegment],
    segmentStart: inout (offset: Int, index: String.UnicodeScalarView.Index)?,
    cursor: (offset: Int, index: String.UnicodeScalarView.Index)
  ) {
    if let segmentStart = segmentStart,
       segmentStart.offset != cursor.offset {
      var segment = code[segmentStart.index..<cursor.index]
      var adjustedOffset = segmentStart.offset
      while segment.first == " " {
        segment.removeFirst()
        adjustedOffset += 1
      }
      segments.append(
        UnicodeSegment(
          scalarOffset: UInt64(adjustedOffset),
          source: UnicodeText(segment)
        )
      )
    }
    segmentStart = nil
  }

  func parsed() -> SayingSource {
    let source = StrictString(self.code)
    var segmentStart: (offset: Int, index: String.UnicodeScalarView.Index)? = nil
    var segments: [UnicodeSegment] = []
    let lastIndex = source.indices.last
    for (offset, index) in source.indices.enumerated() {
      let scalar = source[index]
      if scalar == "\n" {
        registerSegment(
          in: &segments,
          segmentStart: &segmentStart,
          cursor: (offset: offset, index: index)
        )
        if index != lastIndex {
          if segments.last?.source == "\u{2028}" {
            let first = segments.removeLast()
            segments.append(UnicodeSegment(scalarOffset: first.scalarOffset, source: UnicodeText("\u{2029}")))
          } else {
            segments.append(UnicodeSegment(scalarOffset: UInt64(offset), source: UnicodeText("\u{2028}")))
          }
        }
      } else {
        if segmentStart == nil {
          segmentStart = (offset: offset, index: index)
        }
        if index == lastIndex {
          registerSegment(
            in: &segments,
            segmentStart: &segmentStart,
            cursor: (offset: offset + 1, index: source.endIndex)
          )
        }
      }
    }
    return SayingSource(origin: origin, code: .utf8(UnicodeSegments(segments)))
  }
}
