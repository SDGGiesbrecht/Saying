import SDGCollections
import SDGText

protocol InterfaceSyntaxDeclarationProtocol {

  associatedtype ParseError: InterfaceSyntaxDeclarationParseErrorProtocol

  static var keyword: [Localization: StrictString] { get }
  static var keywords: Set<StrictString> { get }

  init(
    keyword: ParsedToken,
    lineBreakAfterKeyword: ParsedToken,
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
      return .failure(Self.ParseError.commonParseError(.keywordMissing))
    }
    guard keyword.token.source ∈ Self.keywords else {
      return .failure(Self.ParseError.commonParseError(.mismatchedKeyword(keyword)))
    }
    var unparsed = source.dropFirst()

    guard let lineBreakAfterKeyword = unparsed.first,
      lineBreakAfterKeyword.token.kind == .lineBreak else {
      return .failure(Self.ParseError.commonParseError(.noLineBreakAfterKeyword(keyword.location.endIndex)))
    }
    unparsed.removeFirst()

    return .success(Self(keyword: keyword, lineBreakAfterKeyword: lineBreakAfterKeyword, unparsedTokens: Array(unparsed), location: location))
  }
}
