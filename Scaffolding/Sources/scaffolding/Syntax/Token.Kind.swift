import SDGText

extension Token {
  enum Kind {

    case openingParenthesis
    case closingParenthesis
    case identifier

    var allowedCharacters: Set<Unicode.Scalar> {
      switch self {
      case .openingParenthesis:
        return ["("]
      case .closingParenthesis:
        return [")"]
      case .identifier:
        var values: [UInt32] = []
        values.append(contentsOf: 0x61...0x7A) // a–z
        return Set(values.lazy.map({ Unicode.Scalar($0)! }))
      }
    }
  }
}
