extension ParsedParameter {
  var definitionOrReference: DefinitionOrReference<ParsedTypeReference> {
    switch type {
    case .type(let type):
      #warning("Dropping arrow.")
      return .definition(ParsedTypeReference(type.type))
    case .reference(let reference):
      return .reference(reference)
    }
  }
}
