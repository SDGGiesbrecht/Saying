extension ParsedParameter {
  var definitionOrReference: DefinitionOrReference<ParameterTypeIntermediate> {
    switch type {
    case .type(let type):
      let passage: ParameterPassage
      switch type {
      case .type(let concrete):
        switch concrete.passage {
        case .none:
          passage = .into
        case .some(.throughArrow):
          passage = .through
        case .some(.bullet):
          passage = .out
        }
      case .statements:
        passage = .into
      }
      return .definition(ParameterTypeIntermediate(passage: passage, type: ParsedTypeReference(type)))
    case .reference(let reference):
      return .reference(reference)
    }
  }
}
