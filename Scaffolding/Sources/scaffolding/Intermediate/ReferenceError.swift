import SDGText

enum ReferenceError: DiagnosticError {
  case noSuchThing(StrictString, reference: ParsedUninterruptedIdentifier)
  case noSuchAction(name: StrictString, reference: ParsedAction)

  var range: Slice<UTF8Segments> {
    switch self {
    case .noSuchThing(_, reference: let identifier):
      return identifier.location
    case .noSuchAction(_, reference: let action):
      return action.location
    }
  }
}
