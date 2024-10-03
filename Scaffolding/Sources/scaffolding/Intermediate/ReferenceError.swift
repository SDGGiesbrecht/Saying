import SDGText

enum ReferenceError: DiagnosticError {
  case noSuchThing(StrictString, reference: ParsedUninterruptedIdentifier)
  case noSuchAction(name: StrictString, reference: ParsedAction)
  case noSuchAbility(name: StrictString, reference: ParsedUseSignature)
  case unfulfilledRequirement(name: Set<StrictString>, ParsedUse)
  case noSuchRequirement(ParsedActionDeclaration)
  case mismatchedParameters(name: StrictString, declaration: ParsedActionName)
  case mismatchedAccess(access: ParsedAccess)
  case mismatchedTestAccess(testAccess: ParsedTestAccess)
  case thingAccessNarrowerThanSignature(reference: ParsedUninterruptedIdentifier)
  case thingUnavailableOutsideTests(reference: ParsedUninterruptedIdentifier)
  case actionUnavailableOutsideTests(reference: ParsedAction)

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
    case .mismatchedAccess(access: let access):
      return access.location
    case .mismatchedTestAccess(testAccess: let testAccess):
      return testAccess.location
    case .thingAccessNarrowerThanSignature(reference: let reference):
      return reference.location
    case .thingUnavailableOutsideTests(reference: let reference):
      return reference.location
    case .actionUnavailableOutsideTests(reference: let reference):
      return reference.location
    }
  }
}
