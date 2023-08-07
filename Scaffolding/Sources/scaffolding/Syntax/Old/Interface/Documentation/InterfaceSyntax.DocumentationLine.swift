extension InterfaceSyntax {

  enum Documentation {
    case empty(ParsedEmptySeparatedNestingGroup<Deferred, OldParsedToken>)
    case nonEmpty(ParsedSeparatedNestingGroup<Deferred, OldParsedToken>)
  }
}

extension InterfaceSyntax.Documentation: AlternateForms {
  var form: ParsedSyntaxNode {
    switch self {
    case .empty(let empty):
      return empty
    case .nonEmpty(let nonEmpty):
      return nonEmpty
    }
  }
}
