extension String {

  init(_ text: UnicodeText) {
    self.init(String.UnicodeScalarView(text))
  }
}
