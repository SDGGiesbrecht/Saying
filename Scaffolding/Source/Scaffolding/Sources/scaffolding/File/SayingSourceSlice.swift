extension SayingSourceSlice {
  var sortableStartPosition: UnicodeSegments.Index {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      return unicode.startIndex
    }
  }
}
