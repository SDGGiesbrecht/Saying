import SDGText

struct NativeThingImplementationParameter {
  var name: StrictString
  var syntaxNode: ParsedUninterruptedIdentifier
}

extension NativeThingImplementationParameter {
  init(_ parameter: ParsedUninterruptedIdentifier) {
    name = parameter.identifierText()
    syntaxNode = parameter
  }
}

extension NativeThingImplementationParameter {
  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeThingImplementationParameter {
    let newName: StrictString
    switch typeLookup[name] {
    case .simple(let simple):
      newName = simple.identifier
    case .compound, .action, .statements:
      #warning("Not implemented yet.")
      newName = ""
    case .none:
      newName = name
    }
    return NativeThingImplementationParameter(
      name: newName,
      syntaxNode: syntaxNode
    )
  }
}
