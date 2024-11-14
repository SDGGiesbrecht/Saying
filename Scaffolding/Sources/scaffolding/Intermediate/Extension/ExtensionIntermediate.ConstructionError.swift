import SDGText

extension ExtensionIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenThing(Thing.ConstructionError)
    case brokenAction(ActionIntermediate.ConstructionError)

    var message: String {
      switch self {
      case .brokenThing(let error):
        return error.message
      case .brokenAction(let error):
        return error.message
      }
    }

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenThing(let error):
        return error.range
      case .brokenAction(let error):
        return error.range
      }
    }
  }
}
