extension ParsedAbilityParameter {

  var name: ParsedUninterruptedIdentifier {
    switch self {
    case .type(let type):
      return type.name
    case .reference(let reference):
      return reference.name
    }
  }

  var definitionOrReference: DefinitionOrReference<Void> {
    switch self {
    case .type:
      return .definition(())
    case .reference(let reference):
      return .reference(reference.reference)
    }
  }
}
