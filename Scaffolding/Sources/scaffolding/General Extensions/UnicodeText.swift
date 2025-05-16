extension UnicodeText {

  init<Scalars>(_ scalars: Scalars) where Scalars : Sequence, Scalars.Element == Unicode.Scalar {
    self.init(String.UnicodeScalarView(scalars))
  }

  init(_ string: String) {
    self.init(string.unicodeScalars)
  }
}

extension UnicodeText: Collection {}

extension UnicodeText: ExpressibleByStringLiteral {

  init(stringLiteral value: String) {
    self.init(value)
  }
}
