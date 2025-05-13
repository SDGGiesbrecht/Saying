extension Ability {
  enum ConstructionError: DiagnosticError {
    case brokenDocumentation(LiteralIntermediate.ConstructionError)
    case brokenParameterInterpolation(Interpolation<AbilityParameterIntermediate>.ConstructionError)
    case brokenRequirement(RequirementIntermediate.ConstructionError)
    case brokenChoice(ActionIntermediate.ConstructionError)
    case redeclaredIdentifier(UnicodeText, [ParsedRequirementDeclarationPrototype])
    case documentedParameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UnicodeSegments> {
      switch self {
      case .brokenDocumentation(let error):
        return error.range
      case .brokenParameterInterpolation(let error):
        return error.range
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
      case .brokenDocumentation(let error):
        return error.message
      case .brokenParameterInterpolation(let error):
        return error.message
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
