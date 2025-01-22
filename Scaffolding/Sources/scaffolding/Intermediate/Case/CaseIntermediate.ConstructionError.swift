extension CaseIntermediate {
  enum ConstructionError: DiagnosticError {
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenNativeCaseImplementation(NativeActionImplementationIntermediate.ConstructionError)
    case invalidImport(ParsedNativeAction)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var message: String {
      switch self {
      case .unknownLanguage:
        return defaultMessage
      case .brokenNativeCaseImplementation(let error):
        return error.message
      case .invalidImport:
        return defaultMessage
      case .documentedParameterNotFound:
        return defaultMessage
      }
    }

    var range: Slice<UnicodeSegments> {
      switch self {
      case .unknownLanguage(let language):
        return language.location
      case .brokenNativeCaseImplementation(let error):
        return error.range
      case .invalidImport(let node):
        return node.location
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
