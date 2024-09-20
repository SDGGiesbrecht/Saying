import SDGText

enum ReferenceError: DiagnosticError {
  case noSuchThing(StrictString, reference: ParsedUninterruptedIdentifier)
  case noSuchAction(name: StrictString, reference: ParsedAction)
  case thingAccessNarrowerThanSignature(reference: ParsedUninterruptedIdentifier)
  case thingUnavailableOutsideTests(reference: ParsedUninterruptedIdentifier)
  case actionUnavailableOutsideTests(reference: ParsedAction)

  var range: Slice<UTF8Segments> {
    switch self {
    case .noSuchThing(_, reference: let identifier):
      return identifier.location
    case .noSuchAction(_, reference: let action):
      return action.location
    case .thingAccessNarrowerThanSignature(reference: let reference):
      return reference.location
    case .thingUnavailableOutsideTests(reference: let reference):
      return reference.location
    case .actionUnavailableOutsideTests(reference: let reference):
      return reference.location
    }
  }
}
