import SDGText

protocol ParsedSyntaxNode {
  var nodeKind: ParsedSyntaxNodeKind { get }
  var children: [ParsedSyntaxNode] { get }

  var context: UnicodeSegments { get }
  var startIndex: UnicodeSegments.Index { get }
  var endIndex: UnicodeSegments.Index { get }
  var location: Slice<UnicodeSegments> { get }

  func mutableNode() -> SyntaxNode
}

extension ParsedSyntaxNode {

  func source() -> UnicodeText {
    return UnicodeText(StrictString(location))
  }

  func formattedGitStyleSource() -> UnicodeText {
    return mutableNode().formattedGitStyleSource()
  }

  func findAllLanguageReferences() -> [ParsedUninterruptedIdentifier] {
    var list: [ParsedUninterruptedIdentifier] = []
    findAllLanguageReferences(list: &list)
    return list
  }
  private func findAllLanguageReferences(list: inout [ParsedUninterruptedIdentifier]) {
    switch nodeKind {
    case .abilityNameEntry(let name):
      list.append(name.language)
    case .actionNameEntry(let name):
      list.append(name.language)
    case .thingNameEntry(let name):
      list.append(name.language)
    case .caseNameEntry(let name):
      list.append(name.language)
    case .paragraphEntry(let paragraph):
      list.append(paragraph.language)
    default:
      if self is SyntaxLeaf {
        break
      } else {
        for child in children {
          child.findAllLanguageReferences(list: &list)
        }
      }
    }
  }
}
