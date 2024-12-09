import SDGText

struct TestIntermediate {
  var location: [Set<StrictString>]
  var statement: StatementIntermediate
}

extension TestIntermediate {

  init(_ test: ParsedTest, location: [Set<StrictString>], index: Int) {
    self.location = location.appending([index.inDigits()])
    self.statement = StatementIntermediate(
      isReturn: false,
      action: ActionUse(test.details.test)
    )
  }
}

extension TestIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location,
      statement: statement.resolvingExtensionContext(typeLookup: typeLookup)
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location.appending(contentsOf: specializationNamespace),
      statement: statement.specializing(typeLookup: typeLookup)
    )
  }
}
