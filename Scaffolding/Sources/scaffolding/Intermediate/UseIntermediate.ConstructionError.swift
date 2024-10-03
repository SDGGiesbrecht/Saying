import SDGText

extension UseIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenAction(ActionIntermediate.ConstructionError)

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenAction(let error):
        return error.range
      }
    }
  }
}
