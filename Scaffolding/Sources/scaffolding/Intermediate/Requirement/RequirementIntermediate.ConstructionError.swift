extension RequirementIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenPrototype(ActionPrototype.ConstructionError)

    var message: String {
      switch self {
      case .brokenPrototype:
        return defaultMessage
      }
    }

    var range: SayingSourceSlice {
      switch self {
      case .brokenPrototype(let error):
        return error.range
      }
    }
  }
}
