import SDGText

struct ParameterIntermediate {
  var names: Set<StrictString>
  var type: StrictString
  var typeDeclaration: ParsedUninterruptedIdentifier?
}
