protocol AlternateForms: DerivedLocation, ParsedSyntaxNode {
  var form: ParsedSyntaxNode { get }
}

extension AlternateForms {
  var firstChild: ParsedSyntaxNode {
    return form
  }
  var lastChild: ParsedSyntaxNode {
    return form
  }
}
