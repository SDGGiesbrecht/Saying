struct Line<Content>: ParsedSyntaxNode
where Content: ParsedSyntaxNode {
  let lineBreak: ParsedToken
  let content: Content
}

extension Line: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return lineBreak
  }
  var lastChild: ParsedSyntaxNode {
    return content
  }
}
