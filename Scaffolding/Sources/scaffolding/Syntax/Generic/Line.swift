struct Line<Content>
where Content: ManualParsedSyntaxNode {
  let lineBreak: ParsedToken
  let content: Content
}

extension Line: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    return [lineBreak, content]
  }
}

extension Line: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return lineBreak
  }
  var lastChild: ManualParsedSyntaxNode {
    return content
  }
}
