import SDGText

protocol ParsedDictionaryTerm: ParsedSyntaxNode {

  associatedtype ParseError: Error

  static func parse(
    source: [OldParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<Self, Self.ParseError>
}

extension ParsedDictionaryTerm where Self: ParsableSyntaxNode {

  static func parse(
    source: [OldParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<Self, ParseError> {
    switch Self.diagnosticParseNext(in: location) {
    case .failure(let errors):
      return .failure(errors.errors.first!)
    case .success(let term):
      guard location[term.location.endIndex...].isEmpty else {
        fatalError("Parsed partial dictionary term: “\(StrictString(location))”")
      }
      return .success(term)
    }
  }
}
extension ParsedUninterruptedIdentifier: ParsedDictionaryTerm, ParsedDictionaryDefinition {}
