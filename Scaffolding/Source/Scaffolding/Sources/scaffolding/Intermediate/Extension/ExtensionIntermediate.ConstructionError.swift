extension ExtensionIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenThing(Thing.ConstructionError)
    case brokenAction(ActionIntermediate.ConstructionError)
    case brokenUse(UseIntermediate.ConstructionError)

    var message: String {
      switch self {
      case .brokenThing(let error):
        return error.message
      case .brokenAction(let error):
        return error.message
      case .brokenUse(let error):
        return error.message
      }
    }

    var range: SayingSourceSlice {
      switch self {
      case .brokenThing(let error):
        return error.range
      case .brokenAction(let error):
        return error.range
      case .brokenUse(let error):
        return error.range
      }
    }
  }
}
