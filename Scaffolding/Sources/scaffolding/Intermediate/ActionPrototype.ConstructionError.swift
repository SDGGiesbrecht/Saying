extension ActionPrototype {
  enum ConstructionError: DiagnosticError {
    case referenceInTypeSignature(ParsedParameter)
    case typeInReferenceSignature(ParsedParameter)
    case multipleTypeSignatures(ParsedSignature)
    case cyclicalParameterReference(ParsedParameter)
    case parameterNotFound(ParsedUninterruptedIdentifier)

    var message: String {
      switch self {
      case .referenceInTypeSignature:
        return defaultMessage
      case .typeInReferenceSignature:
        return defaultMessage
      case .multipleTypeSignatures:
        return defaultMessage
      case .cyclicalParameterReference:
        return defaultMessage
      case .parameterNotFound:
        return defaultMessage
      }
    }

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
      }
    }
  }
}
