import Saying

extension ParsedSourceOrCreationActionImplementation {
  var openingBrace: ParsedOpeningBraceSyntax? {
    switch self {
    case .source(let source):
      return source.openingBrace
    case .creation:
      return nil
    }
  }
}
