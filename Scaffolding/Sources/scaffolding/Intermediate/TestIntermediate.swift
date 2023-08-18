struct TestIntermedate {
  var action: ActionUse
}

extension TestIntermedate {

  init(_ test: ParsedTest) {
    self.action = ActionUse(test.details.test)
  }
}
