struct ParsedColon {
  let leadingSpace: ParsedToken?
  let colon: ParsedToken
  let trailingSpace: ParsedToken
}

extension ParsedColon: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    var result: [ParsedSyntaxNode] = []
    if let leadingSpace = leadingSpace {
      result.append(leadingSpace)
    }
    result.append(contentsOf: [colon, trailingSpace])
    return result
  }
}

extension ParsedColon: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return leadingSpace ?? colon
  }
  var lastChild: ParsedSyntaxNode {
    return trailingSpace
  }
}
