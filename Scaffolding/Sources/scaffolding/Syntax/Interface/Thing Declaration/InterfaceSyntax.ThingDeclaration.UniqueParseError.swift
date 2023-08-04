extension InterfaceSyntax.ThingDeclaration {

  enum UniqueParseError {
    case nameMissing(UTF8Segments.Index)
    case brokenName(ParsedThingNameDeclaration.ParseError)
  }
}
