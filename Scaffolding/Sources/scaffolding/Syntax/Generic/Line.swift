struct Line<Content>
where Content: OldParsedSyntaxNode {
  let lineBreak: ParsedToken
  let content: Content
}

extension Line: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    return [lineBreak, content]
  }
}

extension Line: DerivedLocation {
  var firstChild: OldParsedSyntaxNode {
    return lineBreak
  }
  var lastChild: OldParsedSyntaxNode {
    return content
  }
}
