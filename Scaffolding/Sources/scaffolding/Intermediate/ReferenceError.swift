import SDGText

enum ReferenceError: Error {
  case noSuchThing(StrictString)
  case noSuchAction(name: StrictString, source: ParsedAction?)
}
