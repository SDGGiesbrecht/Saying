extension NativeThingImplementation {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)

    var range: Slice<UTF8Segments> {
      switch self {
      case .literalError(let error):
        return error.range
      }
    }
  }
}
