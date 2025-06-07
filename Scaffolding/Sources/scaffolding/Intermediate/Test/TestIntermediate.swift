struct TestIntermediate {
  var location: [Set<UnicodeText>]
  var statements: [StatementIntermediate]
}

extension TestIntermediate {

  static func construct(
    _ test: ParsedTest,
    location: [Set<UnicodeText>],
    index: Int
  ) -> Result<TestIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    var errors: [LiteralIntermediate.ConstructionError] = []
    let nestedLocation = location.appending([UnicodeText(index.inDigits())])
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
    return .success(TestIntermediate(location: nestedLocation, statements: statements))
  }
}

extension TestIntermediate {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location,
      statements: statements.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
    )
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location.appending(contentsOf: specializationNamespace),
      statements: statements.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
