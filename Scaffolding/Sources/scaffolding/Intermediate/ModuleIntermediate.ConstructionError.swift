import SDGText

extension ModuleIntermediate {

  enum ConstructionError: Error {
    case redeclaredIdentifier(StrictString, [ParsedDeclaration])
    case parameterNotFound(ParsedParameterDocumentation)
  }
}
