import SDGLogic
import SDGCollections
import SDGText

protocol InterfaceSyntaxDeclarationProtocol: DerivedLocation {

  associatedtype ParseError: InterfaceSyntaxDeclarationParseErrorProtocol

  static var keyword: [Localization: StrictString] { get }
  static var keywords: Set<StrictString> { get }

  init(
    keyword: ParsedToken,
    lineBreakAfterKeyword: ParsedToken,
    deferredLines: ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>
  )

  var keyword: ParsedToken { get }
  var lineBreakAfterKeyword: ParsedToken { get }
  var deferredLines: ParsedSeparatedList<
    ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken
  > { get }
}

extension InterfaceSyntaxDeclarationProtocol { // DerivedLocation
  var firstChild: ParsedSyntaxNode {
    return keyword
  }
  var lastChild: ParsedSyntaxNode {
    return deferredLines
  }
}

extension InterfaceSyntaxDeclarationProtocol {

  static func parse(
    lines: ParsedSeparatedList<Deferred, ParsedToken>
  ) -> Result<Self, Self.ParseError> {
    var remainingLines = lines

    guard let keywordLine = remainingLines.removeFirst(),
      let keyword = keywordLine.entry.tokens.first else {
      return .failure(Self.ParseError.commonParseError(.keywordMissing))
    }
    guard keyword.token.source ∈ Self.keywords else {
      return .failure(Self.ParseError.commonParseError(.mismatchedKeyword(keyword)))
    }
    let unexpected = keywordLine.entry.tokens.dropFirst()
    guard unexpected.isEmpty else {
      return .failure(Self.ParseError.commonParseError(.unexpectedTextAfterKeyword(Array(unexpected))))
    }

    guard let keywordSeparator = keywordLine.separator else {
      return .failure(Self.ParseError.commonParseError(.detailsMissing(keyword)))
    }

    switch remainingLines.processNesting(
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
        switch node {
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
          lineBreakAfterKeyword: keywordSeparator,
          deferredLines: grouped
        )
      )
    }
  }
}
