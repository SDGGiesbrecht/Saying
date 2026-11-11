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

  func startLineNumber() -> Int {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return unicode.base[..<unicode.startIndex]
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

  func startColumnNumber() -> Int {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return unicode.base[..<unicode.startIndex]
        .reversed()
        .prefix(while: { $0 != "\u{2028}" && $0 != "\u{2029}" })
        .count + 1
    }
  }

  func legibleStartLocation() -> UnicodeText {
    return "\(origin), \(startLineNumber()), \(startColumnNumber())"
  }
}
