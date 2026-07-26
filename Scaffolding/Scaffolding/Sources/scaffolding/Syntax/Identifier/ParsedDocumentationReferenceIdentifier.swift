extension ParsedDocumentationReferenceIdentifier {

  func identifierText() -> UnicodeText {
    switch self {
    case .simple(let simple):
      return simple.identifierText()
    case .action(let action):
      return action.identifierText()
    }
  }
}
