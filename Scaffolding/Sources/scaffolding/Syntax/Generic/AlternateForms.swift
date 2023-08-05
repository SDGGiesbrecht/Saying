protocol AlternateForms: DerivedLocation, OldParsedSyntaxNode {
  var form: OldParsedSyntaxNode { get }
}

extension AlternateForms { // OldParsedSyntaxNode
  var children: [OldParsedSyntaxNode] {
    return [form]
  }
}

extension AlternateForms { // DerivedLocation
  var firstChild: OldParsedSyntaxNode {
    return form
  }
  var lastChild: OldParsedSyntaxNode {
    return form
  }
}
