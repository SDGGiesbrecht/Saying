extension Thing {
  enum ConstructionError: Error {
    case unknownLanguage(ParsedUninterruptedIdentifier)
  }
}
