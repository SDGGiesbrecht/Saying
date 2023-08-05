import SDGText

protocol ParsableSyntaxNode: ParsedSyntaxNode {
  associatedtype ParseError: Error
  static func parse(source: Slice<UTF8Segments>) -> Result<Self, ParseError>
}

extension ParsableSyntaxNode {

  static func parse(source: UTF8Segments) -> Result<Self, ParseError> {
    return parse(source: source[...])
  }
  static func parse(source: StrictString) -> Result<Self, ParseError> {
    return parse(source: UTF8Segments(source))
  }

  init?(source: Slice<UTF8Segments>) {
    guard let result = try? Self.parse(source: source).get() else {
      return nil
    }
    self = result
  }
  init?(source: UTF8Segments) {
    self.init(source: source[...])
  }
  init?(source: StrictString) {
    self.init(source: UTF8Segments(source))
  }
}
