extension ActionPrototype {
  enum ConstructionError: DiagnosticError {
    case brokenParameterInterpolation(Interpolation<ParameterIntermediate>.ConstructionError)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenParameterInterpolation(let error):
        return error.range
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
