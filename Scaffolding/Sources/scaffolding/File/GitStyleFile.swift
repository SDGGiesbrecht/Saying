import Foundation

import SDGLogic
import SDGCollections
import SDGText
import SDGPersistence

struct GitStyleFile {

  init(source: StrictString) {
    self.source = source
  }

  init(from url: URL) throws {
    self.init(source: try StrictString(from: url))
  }

  let source: StrictString

  private func registerSegment(
    in segments: inout [UTF8Segment],
    segmentStart: inout (offset: Int, index: StrictString.Index)?,
    cursor: (offset: Int, index: StrictString.Index)
  ) {
    if let segmentStart = segmentStart,
       segmentStart.offset != cursor.offset {
      var segment = source[segmentStart.index..<cursor.index]
      var adjustedOffset = segmentStart.offset
      while segment.first == " " {
        segment.removeFirst()
        adjustedOffset += 1
      }
      segments.append(
        UTF8Segment(
          offset: adjustedOffset,
          source: StrictString(segment)
        )
      )
    }
    segmentStart = nil
  }

  func parsed() -> UTF8Segments {
    var segmentStart: (offset: Int, index: StrictString.Index)? = nil
    var segments: [UTF8Segment] = []
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
            segments.append(UTF8Segment(offset: first.offset, source: "\u{2029}"))
          } else {
            segments.append(UTF8Segment(offset: offset, source: "\u{2028}"))
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
    return UTF8Segments(segments)
  }
}
