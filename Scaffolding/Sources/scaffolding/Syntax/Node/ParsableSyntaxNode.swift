protocol ParsableSyntaxNode: ParsedSyntaxNode {
  associatedtype ParseError: DiagnosticError
  static func diagnosticParseNext(
    in remainder: Slice<UnicodeSegments>
  ) -> Result<DiagnosticParseResult<Self>, ErrorList<ParseError>>
  static func fastParseNext(in remainder: Slice<UnicodeSegments>) -> Self?
}

extension ParsableSyntaxNode {

  static func diagnosticParse(source: UnicodeSegments) -> Result<Self, ErrorList<FileParseError<ParseError>>> {
    var remainder = source[...]
    switch diagnosticParseNext(in: remainder) {
    case .failure(let errors):
      return .failure(errors.map({ .brokenNode($0) }))
    case .success(let parsed):
      remainder = remainder[parsed.result.location.endIndex...]
      guard remainder.isEmpty else {
        if let reason = parsed.reasonNotContinued {
          return .failure([.brokenNode(reason)])
        } else {
          return .failure([.extraneousText(remainder)])
        }
      }
      return .success(parsed.result)
    }
  }
  static func diagnosticParse(source: UnicodeText) -> Result<Self, ErrorList<FileParseError<ParseError>>> {
    return diagnosticParse(source: UnicodeSegments(source))
  }

  static func fastParse(source: UnicodeSegments) -> Self? {
    var remainder = source[...]
    guard let parsed = fastParseNext(in: remainder) else {
      return nil
    }
    remainder = remainder[parsed.location.endIndex...]
    guard remainder.isEmpty else {
      return nil
    }
    return parsed
  }
  static func fastParse(source: UnicodeText) -> Self? {
    return fastParse(source: UnicodeSegments(source))
  }

  init?(source: UnicodeSegments) {
    guard let parsed = Self.fastParse(source: source) else {
      return nil
    }
    self = parsed
  }
  init?(source: UnicodeText) {
    self.init(source: UnicodeSegments(source))
  }
}
