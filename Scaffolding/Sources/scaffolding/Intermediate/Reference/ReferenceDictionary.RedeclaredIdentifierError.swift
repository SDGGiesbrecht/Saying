import SDGText

extension ReferenceDictionary {
  struct RedeclaredIdentifierError {
    var identifier: StrictString
    var triggeringDeclaration: ParsedDeclaration
    var conflictingDeclarations: [ParsedDeclaration]
  }
}

extension ReferenceDictionary.RedeclaredIdentifierError: DiagnosticError {
  var range: Slice<UTF8Segments> {
    return triggeringDeclaration.location
  }

  var message: String {
    return defaultMessage + "(\(identifier))"
  }
}
