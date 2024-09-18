extension ActionIntermediate {
  enum ConstructionError: DiagnosticError {
    case referenceInTypeSignature(ParsedParameter)
    case typeInReferenceSignature(ParsedParameter)
    case multipleTypeSignatures(ParsedSignature)
    case cyclicalParameterReference(ParsedParameter)
    case parameterNotFound(ParsedParameterReference)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenNativeActionImplementation(NativeActionImplementation.ConstructionError)
    case invalidImport(ParsedActionImplementation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .referenceInTypeSignature(let parameter):
        return parameter.location
      case .typeInReferenceSignature(let parameter):
        return parameter.location
      case .multipleTypeSignatures(let signature):
        return signature.location
      case .cyclicalParameterReference(let parameter):
        return parameter.location
      case .parameterNotFound(let reference):
        return reference.location
      case .unknownLanguage(let identifier):
        return identifier.location
      case .brokenNativeActionImplementation(let error):
        return error.range
      case .invalidImport(let implementation):
        return implementation.location
      }
    }
  }
}
