import Saying

extension UnicodeText {

  public init(_ string: String) {
    self.init(string.unicodeScalars)
  }
}

extension UnicodeText: ExpressibleByStringInterpolation {}

extension UnicodeText: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self.init(value)
  }
}
