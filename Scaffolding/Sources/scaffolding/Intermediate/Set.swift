extension Set where Element == UnicodeText {

  func identifier() -> UnicodeText {
    return sorted(by: { ($0.count, String($0)) < ($1.count, String($1)) }).first!
  }
}
