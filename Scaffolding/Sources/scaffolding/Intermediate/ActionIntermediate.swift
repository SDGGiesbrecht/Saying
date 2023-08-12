import SDGText

struct ActionIntermediate {
  var names: Set<StrictString>
  var arguments: [StrictString]
  var reorderings: [StrictString: [Int]]
  var returnValue: StrictString?
  var swift: [StrictString]?
  var declaration: ParsedActionDeclaration
}

extension ActionIntermediate {
  init(_ declaration: ParsedActionDeclaration) {
    names = Set(
      declaration.name.names.names
        .lazy.map({ $0.name.name() })
    )
    returnValue = declaration.returnValue?.type.identifierText()

    #error("Not implemented yet.")

    self.declaration = declaration
  }
}
