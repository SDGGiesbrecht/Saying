extension InterfaceSyntax {

  enum Documentation {
    case empty(ParsedEmptySeparatedNestingGroup<Deferred, ParsedToken>)
    case nonEmpty(ParsedSeparatedNestingGroup<Deferred, ParsedToken>)
  }
}

extension InterfaceSyntax.Documentation: AlternateForms {
  var form: ManualParsedSyntaxNode {
    switch self {
    case .empty(let empty):
      return empty
    case .nonEmpty(let nonEmpty):
      return nonEmpty
    }
  }
}
