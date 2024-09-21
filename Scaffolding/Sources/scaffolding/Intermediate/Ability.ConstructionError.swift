import SDGText

extension Ability {
  enum ConstructionError: DiagnosticError {
    case referenceInTypeSignature(ParsedAbilityParameter)
    case typeInReferenceSignature(ParsedAbilityParameter)
    case multipleTypeSignatures(ParsedAbilitySignature)
    case cyclicalParameterReference(ParsedAbilityParameter)
    case parameterNotFound(ParsedAbilityParameterReference)

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
