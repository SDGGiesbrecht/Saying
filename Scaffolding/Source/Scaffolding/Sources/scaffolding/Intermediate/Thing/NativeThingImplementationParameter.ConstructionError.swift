extension NativeThingImplementationParameter {
  enum ConstructionError: DiagnosticError {
    case unknownModifier(ParsedModifiedImplementationParameter)

    var message: String {
      switch self {
      case .unknownModifier:
        return defaultMessage
      }
    }

    var range: SayingSourceSlice {
      switch self {
      case .unknownModifier(let modifier):
        return modifier.location
      }
    }
  }
}
