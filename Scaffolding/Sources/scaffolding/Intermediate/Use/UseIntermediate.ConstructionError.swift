import SDGText

extension UseIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenAction(ActionIntermediate.ConstructionError)

    var message: String {
      switch self {
      case .brokenAction(let error):
        return error.message
      }
    }

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenAction(let error):
        return error.range
      }
    }
  }
}
