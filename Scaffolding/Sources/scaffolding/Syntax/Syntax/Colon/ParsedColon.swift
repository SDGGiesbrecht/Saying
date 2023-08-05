#warning("Remove.")
struct OldParsedColon {
  let leadingSpace: ParsedToken?
  let colon: ParsedToken
  let trailingSpace: ParsedToken
}

extension OldParsedColon: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    var result: [OldParsedSyntaxNode] = []
    if let leadingSpace = leadingSpace {
      result.append(leadingSpace)
    }
    result.append(contentsOf: [colon, trailingSpace])
    return result
  }
}

extension OldParsedColon: DerivedLocation {
  var firstChild: OldParsedSyntaxNode {
    return leadingSpace ?? colon
  }
  var lastChild: OldParsedSyntaxNode {
    return trailingSpace
  }
}
