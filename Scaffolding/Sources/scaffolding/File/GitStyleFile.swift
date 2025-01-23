import Foundation

import SDGText
import SDGPersistence

struct GitStyleFile {

  init(source: UnicodeText) {
    self.source = source
  }

  init(from url: URL) throws {
    self.init(source: UnicodeText(try StrictString(from: url)))
  }

  let source: UnicodeText

  private func registerSegment(
    in segments: inout [UnicodeSegment],
    segmentStart: inout (offset: Int, index: StrictString.Index)?,
    cursor: (offset: Int, index: StrictString.Index)
  ) {
    let source = StrictString(self.source)
    if let segmentStart = segmentStart,
       segmentStart.offset != cursor.offset {
      var segment = source[segmentStart.index..<cursor.index]
      var adjustedOffset = segmentStart.offset
      while segment.first == " " {
        segment.removeFirst()
        adjustedOffset += 1
      }
      segments.append(
        UnicodeSegment(
          scalarOffset: UInt64(adjustedOffset),
          source: UnicodeText(StrictString(segment))
        )
      )
    }
    segmentStart = nil
  }

  func parsed() -> UnicodeSegments {
    let source = StrictString(self.source)
    var segmentStart: (offset: Int, index: StrictString.Index)? = nil
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
          if (segments.last?.source).map({ StrictString($0) }) == "\u{2028}" {
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
    return UnicodeSegments(segments)
  }
}
