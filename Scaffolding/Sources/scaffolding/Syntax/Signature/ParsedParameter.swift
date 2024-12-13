extension ParsedParameter {
  var definitionOrReference: DefinitionOrReference<ParameterTypeIntermediate> {
    switch type {
    case .type(let type):
      let isThrough: Bool
      switch type {
      case .type(let concrete):
        isThrough = concrete.throughArrow != nil
      case .statements:
        isThrough = false
      }
      return .definition(ParameterTypeIntermediate(isThrough: isThrough, type: ParsedTypeReference(type)))
    case .reference(let reference):
      return .reference(reference)
    }
  }
}
