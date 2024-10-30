extension ParsedParameter {
  var definitionOrReference: DefinitionOrReference<ParsedTypeReference> {
    switch type {
    case .type(let type):
      return .definition(ParsedTypeReference(type))
    case .reference(let reference):
      return .reference(reference)
    }
  }
}
