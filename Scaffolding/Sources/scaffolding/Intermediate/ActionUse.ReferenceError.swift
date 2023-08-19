extension ActionUse {

  enum ReferenceError: Error {
    case noSuchAction(ParsedAction)
  }
}
