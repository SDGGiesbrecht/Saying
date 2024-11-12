import SDGText

extension ExtensionIntermediate {
  enum ConstructionError: DiagnosticError {
    case brokenThing(Thing.ConstructionError)

    var message: String {
      switch self {
      case .brokenThing(let error):
        return error.message
      }
    }

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenThing(let error):
        return error.range
      }
    }
  }
}
