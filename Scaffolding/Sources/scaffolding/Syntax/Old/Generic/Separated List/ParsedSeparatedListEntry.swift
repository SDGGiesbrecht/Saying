protocol ParsedSeparatedListEntry: ParsedSyntaxNode {

  associatedtype ParseError: Error

  static func parse(
    source: [OldParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<Self, Self.ParseError>
}
