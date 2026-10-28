import Saying

struct TestIntermediate {
  var location: [Set<UnicodeText>]
  var isHidden: Bool
  var inheritedVisibility: AccessIntermediate
  var statements: StatementListIntermediate
  var fromExtension: Bool
}

extension TestIntermediate {

  static func construct(
    _ test: ParsedTest,
    location: [Set<UnicodeText>],
    index: Int,
    inheritedVisibility: AccessIntermediate
  ) -> Result<TestIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    var errors: [LiteralIntermediate.ConstructionError] = []
    let nestedLocation = location.appending([UnicodeText(String(index))])
    let isHidden = test.visibility != nil
    let statements: [StatementIntermediate]
    switch test.implementation {
    case .short(let short):
      switch ActionUse.construct(short.test) {
      case .failure(let error):
        errors.append(contentsOf: error.errors)
        statements = []
      case .success(let action):
        statements = [StatementIntermediate(isReturn: false, action: action)]
      }
    case .long(let long):
      statements = long.statements.compactMap { statement in
        switch StatementIntermediate.construct(statement) {
        case .failure(let error):
          errors.append(contentsOf: error.errors)
          return nil
        case .success(let constructed):
          return constructed
        }
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      TestIntermediate(
        location: nestedLocation,
        isHidden: isHidden,
        inheritedVisibility: inheritedVisibility,
        statements: StatementListIntermediate(statements: statements),
        fromExtension: false
      )
    )
  }
}

extension TestIntermediate {
  func resolvingExtensionContext() -> TestIntermediate {
    return TestIntermediate(
      location: location,
      isHidden: isHidden,
      inheritedVisibility: inheritedVisibility,
      statements: statements,
      fromExtension: true
    )
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>],
    specializationVisibility: AccessIntermediate
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location + specializationNamespace,
      isHidden: isHidden,
      inheritedVisibility: min(self.inheritedVisibility, specializationVisibility),
      // While in would be intuitive for tests in an extension to have access to abitily parameters, doing so creates a new concrete test for each use, which is wasteful, since there is only one code region and logical flow to test. Tests that actually should be duplicated for each use belong at the ability requirements instead. Thus with no *good* reason to have specialized tests in extensions, this functionality is deliberately disabled. (Though there is no good place yet to put the relevant documentation and diagnostics.)
      statements: fromExtension ? statements : statements.specializing(typeLookup: typeLookup),
      fromExtension: fromExtension
    )
  }
}

extension TestIntermediate {

  func identifier() -> UnicodeText {
    return location.lazy
      .map({ $0.identifier() })
      .joined(separator: ":")
  }
}
