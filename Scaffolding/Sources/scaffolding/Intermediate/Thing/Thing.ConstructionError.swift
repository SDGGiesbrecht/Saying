import SDGText

extension Thing {
  enum ConstructionError: DiagnosticError {
    case brokenParameterInterpolation(Interpolation<ThingParameterIntermediate>.ConstructionError)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenNativeImplementation(NativeThingImplementationIntermediate.ConstructionError)
    case invalidImport(ParsedNativeThingImplementation)
    case documentedParameterNotFound(ParsedParameterDocumentation)
    case brokenPartImplementation(PartIntermediate.ConstructionError)
    case brokenCaseImplementation(CaseIntermediate.ConstructionError)

    var message: String {
      switch self {
      case .brokenParameterInterpolation(let error):
        return error.message
      case .unknownLanguage:
        return defaultMessage
      case .brokenNativeImplementation(let error):
        return error.message
      case .invalidImport:
        return defaultMessage
      case .documentedParameterNotFound:
        return defaultMessage
      case .brokenPartImplementation(let error):
        return error.message
      case .brokenCaseImplementation(let error):
        return error.message
      }
    }

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenParameterInterpolation(let error):
        return error.range
      case .unknownLanguage(let identifier):
        return identifier.location
      case .brokenNativeImplementation(let error):
        return error.range
      case .invalidImport(let implementation):
        return implementation.location
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      case .brokenPartImplementation(let error):
        return error.range
      case .brokenCaseImplementation(let error):
        return error.range
      }
    }
  }
}
