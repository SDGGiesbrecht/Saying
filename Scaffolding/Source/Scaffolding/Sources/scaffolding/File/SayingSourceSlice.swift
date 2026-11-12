import Saying

extension SayingSourceSlice {
  var sortableStartPosition: UnicodeSegments.Index {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return unicode.startIndex
    }
  }
  var hashableStartLocation: HashableSourceLocation {
    return HashableSourceLocation(origin: origin, position: sortableStartPosition)
  }

  private func stableOffset(getIndex: (Slice<UnicodeSegments>) -> Slice<UnicodeSegments>.Index) -> UInt64 {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return unicode.base.underlyingScalarOffset(of: getIndex(unicode))
    }
  }
  func stableStartOffset() -> UInt64 {
    return stableOffset(getIndex: { $0.startIndex })
  }
  func stableEndOffset() -> UInt64 {
    return stableOffset(getIndex: { $0.endIndex })
  }

  private func stableLocation(offset: UInt64) -> UnicodeText {
    return "\(origin), \(offset)"
  }
  func stableStartLocation() -> UnicodeText {
    return stableLocation(offset: stableStartOffset())
  }
  func stableEndLocation() -> UnicodeText {
    return stableLocation(offset: stableEndOffset())
  }

  private func lineNumber(getIndex: (Slice<UnicodeSegments>) -> Slice<UnicodeSegments>.Index) -> Int {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return unicode.base[..<getIndex(unicode)]
        .lazy.map({ scalar in
          switch scalar {
          case "\u{2028}":
            return 1
          case "\u{2029}":
            return 2 // Falsly assumes “.git.utf8.saying” for now.
          default:
            return 0
          }
        }).reduce(1, +)
    }
  }
  func startLineNumber() -> Int {
    return lineNumber(getIndex: { $0.startIndex })
  }
  func endLineNumber() -> Int {
    return lineNumber(getIndex: { $0.endIndex })
  }

  private func columnNumber(getIndex: (Slice<UnicodeSegments>) -> Slice<UnicodeSegments>.Index) -> Int {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return unicode.base[..<getIndex(unicode)]
        .reversed()
        .prefix(while: { $0 != "\u{2028}" && $0 != "\u{2029}" })
        .count + 1
    }
  }
  func startColumnNumber() -> Int {
    return columnNumber(getIndex: { $0.startIndex })
  }
  func endColumnNumber() -> Int {
    return columnNumber(getIndex: { $0.endIndex })
  }

  private func legibleLocation(line: Int, column: Int) -> UnicodeText {
    return "\(origin), \(line), \(column)"
  }
  func legibleStartLocation() -> UnicodeText {
    return legibleLocation(line: startLineNumber(), column: startColumnNumber())
  }
  func legibleEndLocation() -> UnicodeText {
    return legibleLocation(line: endLineNumber(), column: endColumnNumber())
  }
}
