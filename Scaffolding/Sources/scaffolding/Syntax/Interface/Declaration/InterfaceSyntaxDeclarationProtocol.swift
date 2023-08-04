import SDGLogic
import SDGCollections
import SDGText

protocol InterfaceSyntaxDeclarationProtocol: DerivedLocation {

  associatedtype ParseError: InterfaceSyntaxDeclarationParseErrorProtocol

  static var keyword: [Localization: StrictString] { get }
  static var keywords: Set<StrictString> { get }

  static func parseUniqueComponents(
    keyword: ParsedToken,
    documentation: Line<InterfaceSyntax.Documentation>?,
    deferredLines: Line<ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>>
  ) -> Result<Self, ParseError>

  var keyword: ParsedToken { get }
  var documentation: Line<InterfaceSyntax.Documentation>? { get }
}

extension InterfaceSyntaxDeclarationProtocol { // DerivedLocation
  var firstChild: ParsedSyntaxNode {
    return keyword
  }
}

extension InterfaceSyntaxDeclarationProtocol {

  static func parse(
    lines: ParsedSeparatedList<Deferred, ParsedToken>
  ) -> Result<Self, Self.ParseError> {
    var remainingLines = lines

    guard let keywordLine = remainingLines.removeFirst(),
      let keyword = keywordLine.entry.tokens.first else {
      return .failure(Self.ParseError.common(.keywordMissing))
    }
    guard keyword.token.source ∈ Self.keywords else {
      return .failure(Self.ParseError.common(.mismatchedKeyword(keyword)))
    }
    let unexpected = keywordLine.entry.tokens.dropFirst()
    guard unexpected.isEmpty else {
      return .failure(Self.ParseError.common(.unexpectedTextAfterKeyword(Array(unexpected))))
    }
    var remainingSeparator = keywordLine.separator

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
      return .failure(.common(.nestingError(error)))
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
          return .failure(.common(.nestingError(.unpairedElement(opening))))
        }
        if opening.tokens.first!.token.kind == .openingBracket,
          closing.tokens.first!.token.kind ≠ .closingBracket {
          return .failure(.common(.nestingError(.unpairedElement(opening))))
        }
      }
      var remainingGroups = grouped

      var documentationLine: (documentation: InterfaceSyntax.Documentation, separator: ParsedToken?)?
      if let next = remainingGroups.entries?.first {
        switch next {
        case .leaf:
          break
        case .emptyGroup(let group):
          if group.opening.tokens.first?.token.kind == .openingBracket {
            let removed = remainingGroups.removeFirst()!
            documentationLine = (documentation: .empty(group), separator: removed.separator)
          }
        case .group(let group):
          if group.opening.tokens.first?.token.kind == .openingBracket {
            let removed = remainingGroups.removeFirst()!
            documentationLine = (documentation: .nonEmpty(group), separator: removed.separator)
          }
        }
      }
      let documentation: Line<InterfaceSyntax.Documentation>?
      if let line = documentationLine {
        documentation = Line<InterfaceSyntax.Documentation>(
          lineBreak: remainingSeparator!,
          content: line.documentation
        )
        remainingSeparator = documentationLine?.separator
      } else {
        documentation = nil
      }

      guard let detailsSeparator = remainingSeparator else {
        return .failure(
          Self.ParseError.common(.detailsMissing(documentation?.endIndex ?? keyword.endIndex))
        )
      }
      return Self.parseUniqueComponents(
        keyword: keyword,
        documentation: documentation,
        deferredLines: Line(lineBreak: detailsSeparator, content: remainingGroups)
      )
    }
  }
}
