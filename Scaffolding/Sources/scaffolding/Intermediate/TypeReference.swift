import SDGText

struct TypeReference {
  var identifier: StrictString
  var syntaxNode: ParsedUninterruptedIdentifier
}

extension TypeReference {
  init(_ identifier: ParsedUninterruptedIdentifier) {
    self.identifier = identifier.identifierText()
    syntaxNode = identifier
  }
}
