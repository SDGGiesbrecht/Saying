#warning("Remove.")
struct ManualParsedColon {
  let leadingSpace: ParsedToken?
  let colon: ParsedToken
  let trailingSpace: ParsedToken
}

extension ManualParsedColon: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    var result: [ParsedSyntaxNode] = []
    if let leadingSpace = leadingSpace {
      result.append(leadingSpace)
    }
    result.append(contentsOf: [colon, trailingSpace])
    return result
  }
}

extension ManualParsedColon: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return leadingSpace ?? colon
  }
  var lastChild: ParsedSyntaxNode {
    return trailingSpace
  }
}
