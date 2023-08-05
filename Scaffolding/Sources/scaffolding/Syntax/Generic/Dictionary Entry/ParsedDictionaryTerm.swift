protocol ParsedDictionaryTerm: ManualParsedSyntaxNode {

  associatedtype ParseError: Error

  static func parse(
    source: [ParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<Self, Self.ParseError>
}
