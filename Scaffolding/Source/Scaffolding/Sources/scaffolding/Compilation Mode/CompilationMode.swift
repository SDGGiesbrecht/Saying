enum CompilationMode {

  /// Intended for release.
  ///
  /// - Reachable components only
  /// - Reachable documentation
  /// - Small internal identifiers
  /// - No checks
  /// - No test coverage
  /// - All dependencies are also compiled in `.release` mode
  /// - Library access as specified (unit by default)
  case release(LibraryAccessMode)

  /// Intended for use as an external direct dependency during development.
  ///
  /// - Reachable components only
  /// - No documentation
  /// - Small internal identifiers
  /// - Client checks
  /// - No test coverage
  /// - Its own external dependencies are compiled in `.release` mode
  /// - No libraries (but potentially fowarded into a top‐level ones)
  case dependency

  /// Intended to be debugged.
  ///
  /// - All components (to detect errors anywhere)
  /// - No documentation produced (but the contents are still compiled to detect errors)
  /// - Legible internal identifiers (for ease of debugging)
  /// - Self‐checks
  /// - No test coverage
  /// - External dependencies are compiled in `.dependency` mode
  /// - No libraries
  case debugging

  /// Intended to be tested.
  ///
  /// - All components (to detect errors anywhere)
  /// - No documentation produced (but the contents are still compiled to detect errors)
  /// - Legible internal identifiers (for ease of debugging)
  /// - Self checks
  /// - Test coverage
  /// - External dependencies are compiled in`.dependency` mode
  /// - No libraries
  case testing

  /// Intended for exporting source to another format.
  ///
  /// - All components
  /// - All documentation
  /// - Legible internal identifiers
  /// - Self‐checks
  /// - No test coverage
  /// - External dependencies exported separately
  /// - Libraries as units accessible to clients
  case export

  /// Intended for scaffolding the Saying compiler itself.
  ///
  /// - Reachable components only
  /// - No documentation
  /// - Legible internal identifiers (for stability)
  /// - Client checks
  /// - No test coverage
  /// - No external dependencies
  /// - Libraries as units accessible to clients
  case scaffolding

  var hasTestCoverage: Bool {
    switch self {
    case .release, .dependency, .debugging, .export, .scaffolding:
      return false
    case .testing:
      return true
    }
  }

  var libraryAccessMode: LibraryAccessMode {
    switch self {
    case .release(let access):
      return access
    case .dependency, .debugging, .testing:
      return .unit
    case .export, .scaffolding:
      return .clients(.package)
    }
  }
}
