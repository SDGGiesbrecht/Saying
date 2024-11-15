import SDGText

enum ReferenceError: DiagnosticError {
  case noSuchThing(StrictString, reference: ParsedThingReferenceProtocol)
  case noSuchAction(name: StrictString, reference: ParsedAction)
  case noSuchAbility(name: StrictString, reference: ParsedAbilityReferenceProtocol)
  case unfulfilledRequirement(name: Set<StrictString>, ParsedUse)
  case noSuchRequirement(ParsedActionDeclaration)
  case mismatchedParameters(name: StrictString, declaration: ParsedActionName)
  case fulfillmentAccessNarrowerThanRequirement(declaration: ParsedActionName)
  case mismatchedTestAccess(testAccess: ParsedTestAccess)
  case thingAccessNarrowerThanSignature(reference: ParsedThingReferenceProtocol)
  case thingUnavailableOutsideTests(reference: ParsedThingReferenceProtocol)
  case actionUnavailableOutsideTests(reference: ParsedAction)
  case redeclaredLocalIdentifier(error: ReferenceDictionary.RedeclaredIdentifierError)
  case noSuchParameter(ParsedUninterruptedIdentifier)
  case noSuchLanguage(ParsedUninterruptedIdentifier)
  case noSuchIdentifier(ParsedUninterruptedIdentifier)

  var message: String {
    switch self {
    case .noSuchThing:
      return defaultMessage
    case .noSuchAction(name: let name, reference: _):
      return "\(defaultMessage) (\(name))"
    case .noSuchAbility:
      return defaultMessage
    case .unfulfilledRequirement:
      return defaultMessage
    case .noSuchRequirement:
      return defaultMessage
    case .mismatchedParameters:
      return defaultMessage
    case .fulfillmentAccessNarrowerThanRequirement:
      return defaultMessage
    case .mismatchedTestAccess:
      return defaultMessage
    case .thingAccessNarrowerThanSignature:
      return defaultMessage
    case .thingUnavailableOutsideTests:
      return defaultMessage
    case .actionUnavailableOutsideTests:
      return defaultMessage
    case .redeclaredLocalIdentifier(error: let error):
      return error.message
    case .noSuchParameter:
      return defaultMessage
    case .noSuchLanguage:
      return defaultMessage
    case .noSuchIdentifier:
      return defaultMessage
    }
  }

  var range: Slice<UTF8Segments> {
    switch self {
    case .noSuchThing(_, reference: let identifier):
      return identifier.location
    case .noSuchAction(_, reference: let action):
      return action.location
    case .noSuchAbility(_, reference: let use):
      return use.location
    case .unfulfilledRequirement(_, let use):
      return use.location
    case .noSuchRequirement(let declaration):
      return declaration.location
    case .mismatchedParameters(name: _, declaration: let declaration):
      return declaration.location
    case .fulfillmentAccessNarrowerThanRequirement(declaration: let declaration):
      return declaration.location
    case .mismatchedTestAccess(testAccess: let testAccess):
      return testAccess.location
    case .thingAccessNarrowerThanSignature(reference: let reference):
      return reference.location
    case .thingUnavailableOutsideTests(reference: let reference):
      return reference.location
    case .actionUnavailableOutsideTests(reference: let reference):
      return reference.location
    case .redeclaredLocalIdentifier(error: let error):
      return error.range
    case .noSuchParameter(let parameter):
      return parameter.location
    case .noSuchLanguage(let language):
      return language.location
    case .noSuchIdentifier(let identifier):
      return identifier.location
    }
  }
}
