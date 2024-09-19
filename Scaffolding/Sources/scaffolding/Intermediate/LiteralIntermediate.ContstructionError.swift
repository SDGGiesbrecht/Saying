extension LiteralIntermediate {
  enum ConstructionError: DiagnosticError {
    case escapeCodeNotHexadecimal(ParsedIdentifierComponent)
    case escapeCodeNotUnicodeScalar(ParsedIdentifierComponent)

    var range: Slice<UTF8Segments> {
      switch self {
      case .escapeCodeNotHexadecimal(let component):
        return component.location
      case .escapeCodeNotUnicodeScalar(let component):
        return component.location
      }
    }
  }
}
