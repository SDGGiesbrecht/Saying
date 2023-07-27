import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ActionDeclaration: ParsedSyntaxNode {

    static let keyword: [Localization: StrictString] = [
      .english: "action"
    ]
    static let keywords = Set(keyword.values)

    static func parse(
      source: [ParsedToken],
      location: Slice<UTF8Segments>
    ) -> Result<Self, Self.ParseError> {
      guard let keyword = source.first else {
        return .failure(.keywordMissing)
      }
      guard keyword.token.source ∈ ActionDeclaration.keywords else {
        return .failure(.notAnAction)
      }
      return .success(InterfaceSyntax.ActionDeclaration(tokens: source, location: location))
    }

    let tokens: [ParsedToken]
    let location: Slice<UTF8Segments>
  }
}
