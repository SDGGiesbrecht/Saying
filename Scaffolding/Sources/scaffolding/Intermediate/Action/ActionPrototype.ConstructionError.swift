extension ActionPrototype {
  enum ConstructionError: DiagnosticError {
    case brokenDocumentation(LiteralIntermediate.ConstructionError)
    case brokenParameterInterpolation(Interpolation<ParameterIntermediate>.ConstructionError)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UnicodeSegments> {
      switch self {
      case .brokenDocumentation(let error):
        return error.range
      case .brokenParameterInterpolation(let error):
        return error.range
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
