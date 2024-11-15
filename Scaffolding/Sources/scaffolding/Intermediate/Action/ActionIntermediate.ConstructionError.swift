import SDGText

extension ActionIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenPrototype(ActionPrototype.ConstructionError)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenNativeActionImplementation(NativeActionImplementationIntermediate.ConstructionError)
    case invalidImport(ParsedNativeActionImplementation)
    case missingImplementation(language: StrictString, action: ParsedActionName)

    var message: String {
      switch self {
      case .brokenPrototype:
        return defaultMessage
      case .unknownLanguage:
        return defaultMessage
      case .brokenNativeActionImplementation(let error):
        return error.message
      case .invalidImport:
        return defaultMessage
      case .missingImplementation(let language, _):
        return "\(defaultMessage) (\(language))"
      }
    }

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenPrototype(let error):
        return error.range
      case .unknownLanguage(let identifier):
        return identifier.location
      case .brokenNativeActionImplementation(let error):
        return error.range
      case .invalidImport(let implementation):
        return implementation.location
      case .missingImplementation(_, action: let action):
        return action.location
      }
    }
  }
}
