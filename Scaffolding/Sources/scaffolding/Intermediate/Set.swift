import SDGText

extension Set where Element == StrictString {

  func identifier() -> UnicodeText {
    return UnicodeText(sorted(by: { ($0.count, $0) < ($1.count, $1) }).first!)
  }
}
