struct ParsedThingNameDeclaration: ParsedSyntaxNode {
  let deferred: ParsedSeparatedNestingGroup<Deferred, ParsedToken>
}

extension ParsedThingNameDeclaration: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return deferred
  }
  var lastChild: ParsedSyntaxNode {
    return deferred
  }
}
