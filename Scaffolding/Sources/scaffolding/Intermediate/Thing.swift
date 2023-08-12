import SDGText

struct Thing {
  var names: Set<StrictString>
  var swift: StrictString?
  var declaration: ParsedThingDeclaration
}

extension Thing {
  init(_ declaration: ParsedThingDeclaration) {
    names = Set(
      declaration.name.names.names
        .lazy.map({ $0.name.identifierText() })
    )
    swift = declaration.implementation.type.identifierText()
    self.declaration = declaration
  }
}
