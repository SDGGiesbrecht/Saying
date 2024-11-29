extension CaseIntermediate {
  enum ConstructionError: DiagnosticError {
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
