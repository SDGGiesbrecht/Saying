import Saying
import Syntax

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
    return diagnosticParse(source: UnicodeSegments(allOf: source), origin: origin)
  }

  init?(source: UnicodeSegments, origin: UnicodeText) {
    guard let parsed = Self.fastParse(source: source, origin: origin) else {
      return nil
    }
    self = parsed
  }
  init?(source: UnicodeText, origin: UnicodeText) {
    self.init(source: UnicodeSegments(allOf: source), origin: origin)
  }
}
