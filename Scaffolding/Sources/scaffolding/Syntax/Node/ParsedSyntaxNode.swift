import SDGText

protocol ParsedSyntaxNode {
  var nodeKind: ParsedSyntaxNodeKind { get }
  var children: [ParsedSyntaxNode] { get }

  var context: UTF8Segments { get }
  var startIndex: UTF8Segments.Index { get }
  var endIndex: UTF8Segments.Index { get }
  var location: Slice<UTF8Segments> { get }

  func mutableNode() -> SyntaxNode
}

extension ParsedSyntaxNode {

  func source() -> StrictString {
    return StrictString(location)
  }

  func formattedGitStyleSource() -> StrictString {
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
