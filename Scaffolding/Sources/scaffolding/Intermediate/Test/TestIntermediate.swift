import SDGText

struct TestIntermediate {
  var location: [Set<StrictString>]
  var statements: [StatementIntermediate]
}

extension TestIntermediate {

  init(_ test: ParsedTest, location: [Set<StrictString>], index: Int) {
    self.location = location.appending([index.inDigits()])
    switch test.implementation {
    case .short(let short):
      self.statements = [StatementIntermediate(isReturn: false, action: ActionUse(short.test))]
    case .long(let long):
      self.statements = long.test.statements.map { statement in
        return StatementIntermediate(statement)
      }
    }
  }
}

extension TestIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: UnicodeText]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location,
      statements: statements.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location.appending(contentsOf: specializationNamespace),
      statements: statements.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
