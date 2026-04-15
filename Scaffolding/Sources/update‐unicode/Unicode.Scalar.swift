extension Unicode.Scalar {

  init?<Text>(hexadecimal: Text) where Text: StringProtocol {
    guard let value = Int(hexadecimal: hexadecimal) else {
      return nil
    }
    self.init(value)
  }

  var sayingLiteral: String {
    var literal = String(hexadecimal: value)
    while literal.scalars.count < 4 {
      literal = "0\(literal)"
    }
    return literal
  }
}
