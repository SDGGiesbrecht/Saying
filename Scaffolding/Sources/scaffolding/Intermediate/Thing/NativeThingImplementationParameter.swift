import SDGText

struct NativeThingImplementationParameter {
  var name: UnicodeText
  var syntaxNode: ParsedUninterruptedIdentifier
  var resolvedType: ParsedTypeReference?
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
    return NativeThingImplementationParameter(
      name: name,
      syntaxNode: syntaxNode,
      resolvedType: typeLookup[StrictString(name)] ?? resolvedType?.specializing(typeLookup: typeLookup)
    )
  }
}
