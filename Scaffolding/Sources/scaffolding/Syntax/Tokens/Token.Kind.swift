import SDGText

extension Token {
  enum Kind: CaseIterable {

    static func kind(for scalar: Unicode.Scalar) -> Kind? {
      return allCases.first(where: { $0.allowedCharacters.contains(scalar) })
    }

    case paragraphBreak
    case lineBreak
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
    case error

    var allowedCharacters: Set<Unicode.Scalar> {
      switch self {
      case .paragraphBreak:
        return ["\u{2029}"]
      case .lineBreak:
        return ["\u{2028}"]
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
        return ParsedIdentifierComponent.allowed
      case .error:
        return []
      }
    }

    var isSingleScalar: Bool {
      switch self {
      case .paragraphBreak, .lineBreak, .openingParenthesis, .closingParenthesis, .openingBracket, .closingBracket, .openingQuotationMark, .closingQuotationMark, .colon, .symbolInsertion, .space, .error:
        return true
      case .identifier:
        return false
      }
    }
  }
}
