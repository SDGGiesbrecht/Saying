extension NativeThingImplementationIntermediate {
  enum ConstructionError: DiagnosticError {
    case literalError(LiteralIntermediate.ConstructionError)
    case nativeActionError(NativeActionImplementationIntermediate.ConstructionError)
    case nativeRequirementError(NativeRequirementImplementationIntermediate.ConstructionError)

    var range: Slice<UnicodeSegments> {
      switch self {
      case .literalError(let error):
        return error.range
      case .nativeActionError(let error):
        return error.range
      case .nativeRequirementError(let error):
        return error.range
      }
    }
  }
}
