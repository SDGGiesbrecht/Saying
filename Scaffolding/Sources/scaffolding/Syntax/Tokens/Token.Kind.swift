import SDGText

extension Token {
  enum Kind: CaseIterable {

    static func kind(for scalar: Unicode.Scalar) -> Kind? {
      return allCases.first(where: { $0.allowedCharacters.contains(scalar) })
    }

    case paragraphBreak
    case openingParenthesis
    case closingParenthesis
    case openingBracket
    case closingBracket
    case openingQuotationMark
    case closingQuotationMark
    case colon
    case symbolInsertion
    case space
    case identifier

    var allowedCharacters: Set<Unicode.Scalar> {
      switch self {
      case .paragraphBreak:
        return ["\u{2029}"]
      case .openingParenthesis:
        return ["("]
      case .closingParenthesis:
        return [")"]
      case .openingBracket:
        return ["["]
      case .closingBracket:
        return ["]"]
      case .openingQuotationMark:
        return ["“"]
      case .closingQuotationMark:
        return ["”"]
      case .colon:
        return [":"]
      case .symbolInsertion:
        return ["¤"]
      case .space:
        return [" "]
      case .identifier:
        var values: [UInt32] = []
        values.append(0x2E) // .
        values.append(contentsOf: 0x30...0x39) // 0–9
        values.append(contentsOf: 0x41...0x5A) // A–Z
        values.append(contentsOf: 0x61...0x7A) // a–z
        values.append(contentsOf: 0x300...0x302) // ◌̀–◌̂
        values.append(0x308) // “◌̈”
        values.append(0x327) // “◌̧”
        values.append(contentsOf: 0x3B1...0x3C9) // α–ω
        values.append(contentsOf: 0x5D0...0x5EA) // א–ת
        return Set(values.lazy.map({ Unicode.Scalar($0)! }))
      }
    }

    var isSingleScalar: Bool {
      switch self {
      case .paragraphBreak, .openingParenthesis, .closingParenthesis, .openingBracket, .closingBracket, .openingQuotationMark, .closingQuotationMark, .colon, .symbolInsertion, .space:
        return true
      case .identifier:
        return false
      }
    }
  }
}
