extension SayingSourceSlice {
  var sortableStartPosition: UnicodeSegments.Index {
    switch code {
    case .utf8(let unicode):
      return unicode.startIndex
    }
  }
}
