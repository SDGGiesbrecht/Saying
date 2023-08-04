struct ParsedDictionaryEntry<Term, Definition>: ParsedSyntaxNode
where Term: ParsedSyntaxNode, Definition: ParsedSyntaxNode {
  let term: Term
  let colon: ParsedColon
  let definition: Term
}

extension ParsedDictionaryEntry: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return term
  }
  var lastChild: ParsedSyntaxNode {
    return definition
  }
}
