extension PartIntermediate {
  enum ConstructionError: DiagnosticError {
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var message: String {
      switch self {
      case .unknownLanguage:
        return defaultMessage
      case .documentedParameterNotFound:
        return defaultMessage
      }
    }

    var range: Slice<UTF8Segments> {
      switch self {
      case .unknownLanguage(let language):
        return language.location
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
