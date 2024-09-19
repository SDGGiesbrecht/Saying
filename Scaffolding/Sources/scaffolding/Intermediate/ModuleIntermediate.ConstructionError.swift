import SDGText

extension ModuleIntermediate {

  enum ConstructionError: DiagnosticError {
    case redeclaredIdentifier(StrictString, [ParsedDeclaration])
    case parameterNotFound(ParsedParameterDocumentation)

    var range: Slice<UTF8Segments> {
      switch self {
      case .redeclaredIdentifier(_, let declarations):
        return declarations.first!.location
      case .parameterNotFound(let parameter):
        return parameter.location
      }
    }

    var message: String {
      switch self {
      case .redeclaredIdentifier(let identifier, _):
        return defaultMessage + "(\(identifier))"
      case .parameterNotFound:
        return defaultMessage
      }
    }
  }
}
