import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ThingDeclaration: ParsedSyntaxNode {

    static let keyword: [Localization: StrictString] = [
      .english: "thing"
    ]
    static let keywords = Set(keyword.values)

    static func parse(
      source: [ParsedToken],
      location: Slice<UTF8Segments>
    ) -> Result<Self, Self.ParseError> {
      guard let keyword = source.first else {
        return .failure(.keywordMissing)
      }
      guard keyword.token.source ∈ ThingDeclaration.keywords else {
        return .failure(.notAThing)
      }
      return .success(InterfaceSyntax.ThingDeclaration(tokens: source, location: location))
    }

    let tokens: [ParsedToken]
    let location: Slice<UTF8Segments>
  }
}
