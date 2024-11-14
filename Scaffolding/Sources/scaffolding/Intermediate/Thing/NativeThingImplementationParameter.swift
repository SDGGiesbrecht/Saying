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
