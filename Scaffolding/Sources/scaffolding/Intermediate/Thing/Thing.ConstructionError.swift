import SDGText

extension Thing {
  enum ConstructionError: DiagnosticError {
    case brokenParameterInterpolation(Interpolation<AbilityParameterIntermediate>.ConstructionError)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenNativeImplementation(NativeThingImplementation.ConstructionError)
    case invalidImport(ParsedThingImplementation)
    case documentedParameterNotFound(ParsedParameterDocumentation)

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
      }
    }
  }
}
