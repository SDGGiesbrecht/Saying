protocol ParsableSyntaxNode: ParsedSyntaxNode {
  associatedtype ParseError: DiagnosticError
  static func diagnosticParseNext(
    in remainder: Slice<UnicodeSegments>,
    origin: UnicodeText
  ) -> Result<DiagnosticParseResult<Self>, ErrorList<ParseError>>
  static func fastParseNext(in remainder: Slice<UnicodeSegments>, origin: UnicodeText) -> Self?
}

extension ParsableSyntaxNode {

  static func diagnosticParse(source: UnicodeSegments, origin: UnicodeText) -> Result<Self, ErrorList<FileParseError<ParseError>>> {
    var remainder = source[...]
    switch diagnosticParseNext(in: remainder, origin: origin) {
    case .failure(let errors):
      return .failure(errors.map({ .brokenNode($0) }))
    case .success(let parsed):
      remainder = remainder[parsed.result.endIndex...]
      guard remainder.isEmpty else {
        if let reason = parsed.reasonNotContinued {
          return .failure([.brokenNode(reason)])
        } else {
          return .failure([.extraneousText(SayingSourceSlice(origin: origin, code: .utf8(remainder)))])
        }
      }
      return .success(parsed.result)
    }
  }
  static func diagnosticParse(source: UnicodeText, origin: UnicodeText) -> Result<Self, ErrorList<FileParseError<ParseError>>> {
    return diagnosticParse(source: UnicodeSegments(source), origin: origin)
  }

  static func fastParse(source: UnicodeSegments, origin: UnicodeText) -> Self? {
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
    return fastParse(source: UnicodeSegments(source), origin: origin)
  }

  init?(source: UnicodeSegments, origin: UnicodeText) {
    guard let parsed = Self.fastParse(source: source, origin: origin) else {
      return nil
    }
    self = parsed
  }
  init?(source: UnicodeText, origin: UnicodeText) {
    self.init(source: UnicodeSegments(source), origin: origin)
  }
}
