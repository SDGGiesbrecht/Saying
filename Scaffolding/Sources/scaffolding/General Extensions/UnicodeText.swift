extension UnicodeText {

  init<Scalars>(_ scalars: Scalars) where Scalars : Sequence, Scalars.Element == Unicode.Scalar {
    self.init(String.UnicodeScalarView(scalars))
  }
  init(_ text: UnicodeText) {
    self = text
  }

  init(_ string: String) {
    self.init(string.unicodeScalars)
  }
}

extension UnicodeText: CustomStringConvertible {
  var description: String {
    return String(self)
  }
}

extension UnicodeText: ExpressibleByStringInterpolation {
  
}

extension UnicodeText: ExpressibleByStringLiteral {

  init(stringLiteral value: String) {
    self.init(value)
  }
}

extension UnicodeText: Hashable {}
