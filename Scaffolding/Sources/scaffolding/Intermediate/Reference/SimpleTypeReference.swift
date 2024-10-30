import SDGText

struct SimpleTypeReference {
  var identifier: StrictString
  var syntaxNode: ParsedUninterruptedIdentifier
}

extension SimpleTypeReference {
  init(_ identifier: ParsedUninterruptedIdentifier) {
    self.identifier = identifier.identifierText()
    syntaxNode = identifier
  }
}
