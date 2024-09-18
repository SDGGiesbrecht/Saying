import SDGText

extension Thing {
  enum ConstructionError: Error {
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case invalidImport(ParsedThingImplementation)
  }
}
