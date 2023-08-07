struct Line<Content>
where Content: ParsedSyntaxNode {
  let lineBreak: ParsedToken
  let content: Content
}

extension Line: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [lineBreak, content]
  }
}

extension Line: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return lineBreak
  }
  var lastChild: ParsedSyntaxNode {
    return content
  }
}
