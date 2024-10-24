import SDGText

extension Thing {
  enum ConstructionError: DiagnosticError {
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case invalidImport(ParsedThingImplementation)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .unknownLanguage(let identifier):
        return identifier.location
      case .invalidImport(let implementation):
        return implementation.location
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
