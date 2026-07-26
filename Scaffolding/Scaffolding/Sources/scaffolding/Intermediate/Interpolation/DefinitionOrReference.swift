enum DefinitionOrReference<Definition> {
  case definition(Definition)
  case reference(ParsedParameterReference)
}
