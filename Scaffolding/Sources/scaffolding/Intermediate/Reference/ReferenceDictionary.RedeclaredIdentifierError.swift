extension ReferenceDictionary {
  struct RedeclaredIdentifierError {
    var identifier: UnicodeText
    var triggeringDeclaration: ParsedDeclaration
    var conflictingDeclarations: [ParsedDeclaration]
  }
}

extension ReferenceDictionary.RedeclaredIdentifierError: DiagnosticError {
  var range: SayingSourceSlice {
    return triggeringDeclaration.location
  }

  var message: String {
    return defaultMessage + "(\(identifier))"
  }
}
