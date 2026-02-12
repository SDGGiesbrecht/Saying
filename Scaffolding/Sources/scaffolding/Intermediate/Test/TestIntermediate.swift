struct TestIntermediate {
  var location: [Set<UnicodeText>]
  var isHidden: Bool
  var inheritedVisibility: AccessIntermediate
  var statements: StatementListIntermediate
}

extension TestIntermediate {

  static func construct(
    _ test: ParsedTest,
    location: [Set<UnicodeText>],
    index: Int,
    inheritedVisibility: AccessIntermediate
  ) -> Result<TestIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    var errors: [LiteralIntermediate.ConstructionError] = []
    let nestedLocation = location.appending([UnicodeText(index.inDigits())])
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
        statements: StatementListIntermediate(statements: statements)
      )
    )
  }
}

extension TestIntermediate {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location,
      isHidden: isHidden,
      inheritedVisibility: inheritedVisibility,
      statements: statements.resolvingExtensionContext(typeLookup: typeLookup)
    )
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>],
    specializationVisibility: AccessIntermediate
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location.appending(contentsOf: specializationNamespace),
      isHidden: isHidden,
      inheritedVisibility: min(self.inheritedVisibility, specializationVisibility),
      statements: statements.specializing(typeLookup: typeLookup)
    )
  }
}
