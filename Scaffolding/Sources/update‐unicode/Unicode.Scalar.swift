extension Unicode.Scalar {

  init?<Text>(hexadecimal: Text) where Text: StringProtocol {
    guard let value = Int(hexadecimal: hexadecimal) else {
      return nil
    }
    self.init(value)
  }
}
