import SDGText

extension ModuleIntermediate {

  enum ConstructionError: DiagnosticError {
    case restrictedLanguage(ParsedLanguageDeclaration)
    case redeclaredIdentifier(ReferenceDictionary.RedeclaredIdentifierError)
    case parameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .restrictedLanguage(let declaration):
        return declaration.access?.location ?? declaration.name.location
      case .redeclaredIdentifier(let error):
        return error.range
      case .parameterNotFound(let parameter):
        return parameter.location
      }
    }

    var message: String {
      switch self {
      case .restrictedLanguage:
        return defaultMessage
      case .redeclaredIdentifier(let error):
        return error.message
      case .parameterNotFound:
        return defaultMessage
      }
    }
  }
}
