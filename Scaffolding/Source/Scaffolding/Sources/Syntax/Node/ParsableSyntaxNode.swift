import Saying

public protocol ParsableSyntaxNode: ParsedSyntaxNode {
  associatedtype ParseError: DiagnosticError
  static func diagnosticParseNext(
    in remainder: Slice<UnicodeSegments>,
    origin: UnicodeText
  ) -> Result<DiagnosticParseResult<Self>, ErrorList<ParseError>>
  static func fastParseNext(in remainder: Slice<UnicodeSegments>, origin: UnicodeText) -> Self?
}

extension ParsableSyntaxNode {

  public static func fastParse(source: UnicodeSegments, origin: UnicodeText) -> Self? {
    var remainder = source[...]
    guard let parsed = fastParseNext(in: remainder, origin: origin) else {
      return nil
    }
    remainder = remainder[parsed.endIndex...]
    guard remainder.isEmpty else {
      return nil
    }
    return parsed
  }
  static func fastParse(source: UnicodeText, origin: UnicodeText) -> Self? {
    return fastParse(source: UnicodeSegments(allOf: source), origin: origin)
  }
}
