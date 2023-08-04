struct ParsedColon: ParsedSyntaxNode {
  let leadingSpace: ParsedToken?
  let colon: ParsedToken
  let trailingSpace: ParsedToken
}

extension ParsedColon: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return leadingSpace ?? colon
  }
  var lastChild: ParsedSyntaxNode {
    return trailingSpace
  }
}
