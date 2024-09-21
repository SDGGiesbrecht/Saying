extension ParsedAbilityParameter {

  var name: ParsedUninterruptedIdentifier {
    switch self {
    case .type(let type):
      return type.name
    case .reference(let reference):
      return reference.name
    }
  }
}
