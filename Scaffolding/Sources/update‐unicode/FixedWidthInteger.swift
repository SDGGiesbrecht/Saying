extension FixedWidthInteger {

  init?<Text>(hexadecimal string: Text) where Text: StringProtocol {
    self.init(string, radix: 16)
  }
}
