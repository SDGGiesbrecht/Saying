import SDGText

extension Ability {
  enum ConstructionError: DiagnosticError {
    case referenceInTypeSignature(ParsedAbilityParameter)
    case typeInReferenceSignature(ParsedAbilityParameter)
    case multipleTypeSignatures(ParsedAbilitySignature)
    case cyclicalParameterReference(ParsedAbilityParameter)
    case parameterNotFound(ParsedAbilityParameterReference)
    case brokenRequirement(RequirementIntermediate.ConstructionError)
    case redeclaredIdentifier(StrictString, [ParsedRequirementDeclarationPrototype])
    case documentedParameterNotFound(ParsedParameterDocumentation)

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
      case .brokenRequirement(let error):
        return error.range
      case .redeclaredIdentifier(_, let declarations):
        return declarations.first!.location
      case .documentedParameterNotFound(let parameter):
        return parameter.location
      }
    }

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
      case .brokenRequirement:
        return defaultMessage
      case .redeclaredIdentifier(let identifier, _):
        return defaultMessage + "(\(identifier))"
      case .documentedParameterNotFound:
        return defaultMessage
      }
    }
  }
}
