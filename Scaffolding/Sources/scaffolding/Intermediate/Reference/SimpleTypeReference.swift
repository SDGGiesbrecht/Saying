struct SimpleTypeReference {
  var identifier: UnicodeText
  var syntaxNode: ParsedUninterruptedIdentifier
}

extension SimpleTypeReference {
  init(_ identifier: ParsedUninterruptedIdentifier) {
    self.identifier = identifier.identifierText()
    syntaxNode = identifier
  }
}
