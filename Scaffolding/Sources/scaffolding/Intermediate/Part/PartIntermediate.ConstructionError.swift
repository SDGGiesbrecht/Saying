extension PartIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenDocumentation(LiteralIntermediate.ConstructionError)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenNativeCaseImplementation(NativeActionImplementationIntermediate.ConstructionError)
    case invalidCondition(ParsedAvailabilityCondition)
    case invalidImport(ParsedNativeAction)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var message: String {
      switch self {
      case .brokenDocumentation(let error):
        return error.message
      case .unknownLanguage:
        return defaultMessage
      case .brokenNativeCaseImplementation(let error):
        return error.message
      case .invalidCondition:
        return defaultMessage
      case .invalidImport:
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
      case .brokenNativeCaseImplementation(let error):
        return error.range
      case .invalidCondition(let node):
        return node.location
      case .invalidImport(let node):
        return node.location
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
