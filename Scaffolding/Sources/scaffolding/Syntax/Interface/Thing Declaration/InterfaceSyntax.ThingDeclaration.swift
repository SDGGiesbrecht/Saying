import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ThingDeclaration {
    let keyword: ParsedToken
    let documentation: Line<InterfaceSyntax.Documentation>?
    let name: ParsedThingNameDeclaration
    let deferredLines: Line<
      ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>
    >
  }
}

extension InterfaceSyntax.ThingDeclaration: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    var result: [OldParsedSyntaxNode] = [keyword]
    if let documentation = documentation {
      result.append(documentation)
    }
    result.append(contentsOf: [name, deferredLines])
    return result
  }
}

extension InterfaceSyntax.ThingDeclaration: DerivedLocation {
  var lastChild: OldParsedSyntaxNode {
    return deferredLines
  }
}

extension InterfaceSyntax.ThingDeclaration: InterfaceSyntaxDeclarationProtocol {

  static let keyword: [Localization: StrictString] = [
    .english: "thing"
  ]
  static let keywords = Set(keyword.values)

  static func parseUniqueComponents(
    keyword: ParsedToken,
    documentation: Line<InterfaceSyntax.Documentation>?,
    deferredLines: Line<ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>>
  ) -> Result<InterfaceSyntax.ThingDeclaration, ParseError> {
    var remainingGroups = deferredLines.content
    var remainingSeparator: ParsedToken? = nil

    guard let next = remainingGroups.entries?.first else {
      return .failure(.unique(.nameMissing(remainingGroups.startIndex)))
    }
    switch next {
    case .leaf(let leaf):
      return .failure(.unique(.nameMissing(leaf.startIndex)))
    case .emptyGroup(let group):
      return .failure(.unique(.nameMissing(group.closing.startIndex)))
    case .group(let group):
      guard group.opening.tokens.first?.token.kind == .openingParenthesis else {
        return .failure(.unique(.nameMissing(group.startIndex)))
      }
      let removed = remainingGroups.removeFirst()!
      remainingSeparator = removed.separator
      switch ParsedThingNameDeclaration.parse(source: group) {
      case .failure(let error):
        return .failure(.unique(.brokenName(error)))
      case .success(let name):

        guard let detailsSeparator = remainingSeparator else {
          return .failure(
            Self.ParseError.common(.detailsMissing(documentation?.endIndex ?? keyword.endIndex))
          )
        }

        return .success(
          InterfaceSyntax.ThingDeclaration(
            keyword: keyword,
            documentation: documentation,
            name: name,
            deferredLines: Line(lineBreak: detailsSeparator, content: remainingGroups)
          )
        )
      }
    }
  }
}
