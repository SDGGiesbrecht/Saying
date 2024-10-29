import SDGText

extension Ability {
  enum ConstructionError: DiagnosticError {
    case brokenParameterInterpolation(Interpolation<AbilityParameterIntermediate>.ConstructionError)
    #warning("Dead?")
    case parameterNotFound(ParsedAbilityParameterReference)
    case brokenRequirement(RequirementIntermediate.ConstructionError)
    case brokenChoice(ActionIntermediate.ConstructionError)
    case redeclaredIdentifier(StrictString, [ParsedRequirementDeclarationPrototype])
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .brokenParameterInterpolation(let error):
        return error.range
      case .parameterNotFound(let reference):
        return reference.location
      case .brokenRequirement(let error):
        return error.range
      case .brokenChoice(let error):
        return error.range
      case .redeclaredIdentifier(_, let declarations):
        return declarations.first!.location
      case .documentedParameterNotFound(let parameter):
        return parameter.location
      }
    }

    var message: String {
      switch self {
      case .brokenParameterInterpolation(let error):
        return error.message
      case .parameterNotFound:
        return defaultMessage
      case .brokenRequirement:
        return defaultMessage
      case .brokenChoice:
        return defaultMessage
      case .redeclaredIdentifier(let identifier, _):
        return defaultMessage + "(\(identifier))"
      case .documentedParameterNotFound:
        return defaultMessage
      }
    }
  }
}
