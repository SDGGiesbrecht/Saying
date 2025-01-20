import SDGText

struct LiteralIntermediate {
  var string: String
}

extension LiteralIntermediate {

  static let codeCharacters: Set<Unicode.Scalar> = [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
  ]

  static func construct(
    literal: ParsedLiteral
  ) -> Result<LiteralIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    let contents: [ParsedLiteralComponent]
    switch literal {
    case .chevrons(let literal):
      contents = literal.contents
    case .sixNine(let literal):
      contents = literal.contents
    case .lowSix(let literal):
      contents = literal.contents
    }
    var string = ""
    var errors: [ConstructionError] = []
    for segment in contents {
      switch segment {
      case .segment(let text):
        string.append(contentsOf: String(StrictString(text.source())))
      case .escape(let symbol):
        let code = symbol.code
        let codeSource = StrictString(code.source())
        if !codeSource.allSatisfy({ codeCharacters.contains($0) }) {
          errors.append(.escapeCodeNotHexadecimal(code))
        }
        if let value = UInt32(String(codeSource), radix: 16),
           let scalar = Unicode.Scalar(value) {
          string.unicodeScalars.append(scalar)
        } else {
          errors.append(.escapeCodeNotUnicodeScalar(code))
        }
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(LiteralIntermediate(string: string))
  }
}
