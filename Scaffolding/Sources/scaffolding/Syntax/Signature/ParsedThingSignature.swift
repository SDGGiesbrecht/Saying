import SDGText

extension ParsedThingSignature {

  func identifierSegments() -> [ParsedIdentifierSegment?] {
    switch self {
    case .simple(let simple):
      return [simple]
    case .compound(let compound):
      return compound.identifierSegments()
    }
  }

  func name() -> UnicodeText {
    return UnicodeText(
      identifierSegments().lazy.map({ ($0?.identifierText()).map({ StrictString($0 )}) ?? "" }).joined(separator: "()")
    )
  }

  var parameters: ParsedAbilityParameterList? {
    switch self {
    case .simple:
      return nil
    case .compound(let compound):
      return compound.parameters
    }
  }
}
