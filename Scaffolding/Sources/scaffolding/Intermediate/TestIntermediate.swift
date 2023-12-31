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
