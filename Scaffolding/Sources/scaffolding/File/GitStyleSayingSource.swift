import Foundation

import SDGText
import SDGPersistence

extension GitStyleSayingSource {

  init(from url: URL) throws {
    self.init(origin: UnicodeText(url.path), code: UnicodeText(try String(from: url)))
  }

  private func registerSegment(
    in segments: inout [UnicodeSegment],
    segmentStart: inout GitStyleParsingCursor?,
    cursor: GitStyleParsingCursor
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
    var segmentStart: GitStyleParsingCursor? = nil
    var segments: [UnicodeSegment] = []
    let lastIndex = source.indices.last
    for (offset, index) in source.indices.enumerated() {
      let scalar = source[index]
      if scalar == "\n" {
        registerSegment(
          in: &segments,
          segmentStart: &segmentStart,
          cursor: GitStyleParsingCursor(index: index, offset: UInt64(offset))
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
          segmentStart = GitStyleParsingCursor(index: index, offset: UInt64(offset))
        }
        if index == lastIndex {
          registerSegment(
            in: &segments,
            segmentStart: &segmentStart,
            cursor: GitStyleParsingCursor(index: source.endIndex, offset: UInt64(offset) + 1)
          )
        }
      }
    }
    return SayingSource(origin: origin, code: .utf8(UnicodeSegments(segments)))
  }
}
