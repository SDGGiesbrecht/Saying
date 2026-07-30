import Saying
import Syntax

extension ParsedSyntaxNode {

  func formattedGitStyleSource() -> UnicodeText {
    return mutableNode().formattedGitStyleSource()
  }

  func findAllLanguageReferences() -> [ParsedUninterruptedIdentifier] {
    var list: [ParsedUninterruptedIdentifier] = []
    findAllLanguageReferences(list: &list)
    return list
  }
  private func findAllLanguageReferences(list: inout [ParsedUninterruptedIdentifier]) {
    switch self {
    case let name as ParsedAbilityNameEntry:
      list.append(name.language)
    case let name as ParsedActionNameEntry:
      list.append(name.language)
    case let name as ParsedThingNameEntry:
      list.append(name.language)
    case let name as ParsedCaseNameEntry:
      list.append(name.language)
    case let paragraph as ParsedParagraphEntry:
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
