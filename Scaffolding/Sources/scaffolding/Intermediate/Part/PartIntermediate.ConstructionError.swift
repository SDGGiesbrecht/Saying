extension PartIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenDocumentation(LiteralIntermediate.ConstructionError)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var message: String {
      switch self {
      case .brokenDocumentation(let error):
        return error.message
      case .unknownLanguage:
        return defaultMessage
      case .documentedParameterNotFound:
        return defaultMessage
      }
    }

    var range: SayingSourceSlice {
      switch self {
      case .brokenDocumentation(let error):
        return error.range
      case .unknownLanguage(let language):
        return language.location
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
