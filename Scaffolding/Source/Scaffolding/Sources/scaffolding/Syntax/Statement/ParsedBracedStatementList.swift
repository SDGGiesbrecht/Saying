import Saying

extension ParsedBracedStatementList {
  var openingBrace: ParsedOpeningBraceSyntax {
    switch self {
    case .empty(let empty):
      return empty.openingBrace
    case .nonEmpty(let list):
      return list.openingBrace
    }
  }
  var statements: [ParsedStatement] {
    switch self {
    case .empty:
      return []
    case .nonEmpty(let list):
      return list.statements.statements
    }
  }
}
