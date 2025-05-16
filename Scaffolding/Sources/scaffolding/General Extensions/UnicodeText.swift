import SDGText

extension UnicodeText {
  init(_ string: String) {
    self.init(string.unicodeScalars)
  }

  init(_ string: StrictString) {
    self.init(String(string))
  }
}

extension UnicodeText: Collection {}
