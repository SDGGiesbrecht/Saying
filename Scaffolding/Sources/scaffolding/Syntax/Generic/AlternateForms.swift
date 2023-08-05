protocol AlternateForms: DerivedLocation, ManualParsedSyntaxNode {
  var form: ManualParsedSyntaxNode { get }
}

extension AlternateForms { // ManualParsedSyntaxNode
  var children: [ManualParsedSyntaxNode] {
    return [form]
  }
}

extension AlternateForms { // DerivedLocation
  var firstChild: ManualParsedSyntaxNode {
    return form
  }
  var lastChild: ManualParsedSyntaxNode {
    return form
  }
}
