import SDGText

struct ParsedTypeReference {
  var identifier: StrictString
  var syntaxNode: ParsedUninterruptedIdentifier
}

extension ParsedTypeReference {
  init(_ identifier: ParsedUninterruptedIdentifier) {
    self.identifier = identifier.identifierText()
    syntaxNode = identifier
  }
}

extension ParsedTypeReference {
  var key: TypeReference {
    return .simple(identifier)
  }
}
