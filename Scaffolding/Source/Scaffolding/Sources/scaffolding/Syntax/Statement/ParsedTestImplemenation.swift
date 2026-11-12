import Saying

extension ParsedTestImplemenation {
  var openingBrace: ParsedOpeningBraceSyntax {
    switch self {
    case .short(let short):
      return short.openingBrace
    case .long(let long):
      return long.openingBrace
    }
  }
}
