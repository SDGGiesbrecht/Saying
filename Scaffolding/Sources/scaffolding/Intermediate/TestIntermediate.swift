import SDGText

struct TestIntermediate {
  var location: [Set<StrictString>]
  var action: ActionUse
}

extension TestIntermediate {

  init(_ test: ParsedTest, location: [Set<StrictString>], index: Int) {
    self.location = location.appending([index.inDigits()])
    self.action = ActionUse(test.details.test)
  }
}

extension TestIntermediate {

  func specializing(
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> TestIntermediate {
    return TestIntermediate(
      location: location.appending(contentsOf: specializationNamespace),
      action: action.specializing(typeLookup: typeLookup)
    )
  }
}
