import SDGCollections
import SDGText

protocol InterfaceSyntaxDeclarationProtocol {

  associatedtype ParseError: InterfaceSyntaxDeclarationParseErrorProtocol

  static var keyword: [Localization: StrictString] { get }
  static var keywords: Set<StrictString> { get }

  init(
    keyword: ParsedToken,
    unparsedTokens: [ParsedToken],
    location: Slice<UTF8Segments>
  )
}

extension InterfaceSyntaxDeclarationProtocol {

  static func parse(
    source: [ParsedToken],
    location: Slice<UTF8Segments>
  ) -> Result<Self, Self.ParseError> {
    guard let keyword = source.first else {
      return .failure(Self.ParseError.keywordMissing)
    }
    guard keyword.token.source ∈ Self.keywords else {
      return .failure(Self.ParseError.mismatchedKeyword)
    }
    let unparsed = Array(source.dropFirst())
    return .success(Self(keyword: keyword, unparsedTokens: unparsed, location: location))
  }
}
