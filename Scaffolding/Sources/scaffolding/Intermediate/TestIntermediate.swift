struct TestIntermediate {
  var action: ActionUse
}

extension TestIntermediate {

  init(_ test: ParsedTest) {
    self.action = ActionUse(test.details.test)
  }
}
