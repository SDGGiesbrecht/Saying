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
    deferredLines: ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>,
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

    let remainderLocation = firstContinuation.entry.location.base[
      firstContinuation.entry.location.startIndex..<lines.location.endIndex
    ]
    let remainder = ParsedSeparatedList<Deferred, ParsedToken>(
      entries: ParsedNonEmptySeparatedList(
        first: firstContinuation.entry,
        continuations: Array(continuations),
        location: remainderLocation
      ),
      location: remainderLocation
    )

    switch remainder.processNesting(
      isOpening: { node in
        guard node.tokens.count == 1,
          let kind = node.tokens.first?.token.kind else {
          return false
        }
        return kind == .openingParenthesis ∨ kind == .openingBracket
      },
      isClosing: { node in
        guard node.tokens.count == 1,
          let kind = node.tokens.first?.token.kind else {
          return false
        }
        return kind == .closingParenthesis ∨ kind == .closingBracket
      }
    ) {
    case .failure(let error):
      return .failure(.commonParseError(.nestingError(error)))
    case .success(let grouped):
      scan: for node in grouped.combinedEntries {
        let opening: Deferred
        let closing: Deferred
        switch node.kind {
        case .leaf:
          continue scan
        case .emptyGroup(let group):
          opening = group.opening
          closing = group.closing
        case .group(let group):
          opening = group.opening
          closing = group.closing
        }
        if opening.tokens.first!.token.kind == .openingParenthesis,
          closing.tokens.first!.token.kind ≠ .closingParenthesis {
          return .failure(.commonParseError(.nestingError(.unpairedElement(opening))))
        }
        if opening.tokens.first!.token.kind == .openingBracket,
          closing.tokens.first!.token.kind ≠ .closingBracket {
          return .failure(.commonParseError(.nestingError(.unpairedElement(opening))))
        }
      }
      return .success(
        Self(
          keyword: keyword,
          lineBreakAfterKeyword: firstContinuation.separator,
          deferredLines: grouped,
          location: location
        )
      )
    }
  }
}
