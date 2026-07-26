extension ParsedBracedStatementList {
  var statements: [ParsedStatement] {
    switch self {
    case .empty:
      return []
    case .nonEmpty(let list):
      return list.statements.statements
    }
  }
}
