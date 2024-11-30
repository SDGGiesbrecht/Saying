extension CaseIntermediate {
  enum ConstructionError: DiagnosticError {
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenNativeCaseImplementation(NativeActionImplementationIntermediate.ConstructionError)
    case invalidImport(ParsedNativeActionImplementation)
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .unknownLanguage(let language):
        return language.location
      case .brokenNativeCaseImplementation(let error):
        return error.range
      case .invalidImport(let node):
        return node.location
      case .documentedParameterNotFound(let documentation):
        return documentation.location
      }
    }
  }
}
