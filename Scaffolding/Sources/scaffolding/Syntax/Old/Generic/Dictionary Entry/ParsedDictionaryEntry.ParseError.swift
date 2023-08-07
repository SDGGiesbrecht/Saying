extension ParsedDictionaryEntry where Term: ParsedDictionaryTerm, Definition: ParsedDictionaryDefinition {

  enum ParseError: Error {
    case missingDefinition(UTF8Segments.Index)
    case colonNotFollowedBySpace(UTF8Segments.Index)
    case termParseError(Term.ParseError)
    case definitionParseError(Definition.ParseError)
  }
}
