import SDGLogic
import SDGCollections
import SDGText

protocol InterfaceSyntaxDeclarationProtocol {

  associatedtype ParseError: InterfaceSyntaxDeclarationParseErrorProtocol

  static var keyword: [Localization: StrictString] { get }
  static var keywords: Set<StrictString> { get }

  init(
    keyword: ParsedToken,
    lineBreakAfterKeyword: ParsedToken,
    deferredLines: ParsedSeparatedList<Deferred, ParsedToken>,
    location: Slice<UTF8Segments>
  )
}

extension InterfaceSyntaxDeclarationProtocol {

  static func parse(
    lines: ParsedSeparatedList<Deferred, ParsedToken>,
    location: Slice<UTF8Segments>
  ) -> Result<Self, Self.ParseError> {

    guard let firstLine = lines.entries?.first,
      let keyword = firstLine.tokens.first else {
      return .failure(Self.ParseError.commonParseError(.keywordMissing))
    }
    guard keyword.token.source ∈ Self.keywords else {
      return .failure(Self.ParseError.commonParseError(.mismatchedKeyword(keyword)))
    }
    let unexpected = firstLine.tokens.dropFirst()
    guard unexpected.isEmpty else {
      return .failure(Self.ParseError.commonParseError(.unexpectedTextAfterKeyword(Array(unexpected))))
    }

    guard var continuations = lines.entries?.continuations,
      let firstContinuation = continuations.first else {
      return .failure(Self.ParseError.commonParseError(.detailsMissing(keyword)))
    }
    continuations.removeFirst()

    let first = firstContinuation.entry
    let listLocation = [first, continuations.last ?? first].location()!
    return .success(
      Self(
        keyword: keyword,
        lineBreakAfterKeyword: firstContinuation.separator,
        deferredLines: ParsedSeparatedList(
          entries: ParsedNonEmptySeparatedList(
            first: first,
            continuations: continuations,
            location: listLocation
          ),
          location: listLocation),
        location: location
      )
    )
  }
}
