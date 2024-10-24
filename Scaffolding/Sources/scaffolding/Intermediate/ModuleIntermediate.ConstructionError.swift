import SDGText

extension ModuleIntermediate {

  enum ConstructionError: DiagnosticError {
    case restrictedLanguage(ParsedLanguageDeclaration)
    case redeclaredIdentifier(StrictString, [ParsedDeclaration])
    case parameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .restrictedLanguage(let declaration):
        return declaration.access?.location ?? declaration.name.location
      case .redeclaredIdentifier(_, let declarations):
        return declarations.first!.location
      case .parameterNotFound(let parameter):
        return parameter.location
      }
    }

    var message: String {
      switch self {
      case .restrictedLanguage:
        return defaultMessage
      case .redeclaredIdentifier(let identifier, _):
        return defaultMessage + "(\(identifier))"
      case .parameterNotFound:
        return defaultMessage
      }
    }
  }
}
