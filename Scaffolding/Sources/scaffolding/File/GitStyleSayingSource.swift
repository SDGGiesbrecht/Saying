import Foundation

import SDGText
import SDGPersistence

extension GitStyleSayingSource {

  init(from url: URL) throws {
    self.init(origin: UnicodeText(url.path), code: UnicodeText(try String(from: url)))
  }

  func parsed() -> SayingSource {
    let source = StrictString(self.code)
    var segmentStart: GitStyleParsingCursor? = nil
    var segments: [UnicodeSegment] = []
    let lastIndex = source.indices.last
    for (offset, index) in source.indices.enumerated() {
      let scalar = source[index]
      if scalar == "\n" {
        parseLine(
          in: self,
          from: &segmentStart,
          to: GitStyleParsingCursor(index: index, offset: UInt64(offset)),
          into: &segments
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
          parseLine(
            in: self,
            from: &segmentStart,
            to: GitStyleParsingCursor(index: source.endIndex, offset: UInt64(offset) + 1),
            into: &segments
          )
        }
      }
    }
    return SayingSource(origin: origin, code: .utf8(UnicodeSegments(segments)))
  }
}
