protocol AlternateForms: DerivedLocation, ParsedSyntaxNode {
  var form: ParsedSyntaxNode { get }
}

extension AlternateForms { // ParsedSyntaxNode
  var children: [ParsedSyntaxNode] {
    return [form]
  }
}

extension AlternateForms { // DerivedLocation
  var firstChild: ParsedSyntaxNode {
    return form
  }
  var lastChild: ParsedSyntaxNode {
    return form
  }
}
