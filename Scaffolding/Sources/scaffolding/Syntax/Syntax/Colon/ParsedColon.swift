#warning("Remove.")
struct ManualParsedColon {
  let leadingSpace: ParsedToken?
  let colon: ParsedToken
  let trailingSpace: ParsedToken
}

extension ManualParsedColon: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    var result: [ManualParsedSyntaxNode] = []
    if let leadingSpace = leadingSpace {
      result.append(leadingSpace)
    }
    result.append(contentsOf: [colon, trailingSpace])
    return result
  }
}

extension ManualParsedColon: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return leadingSpace ?? colon
  }
  var lastChild: ManualParsedSyntaxNode {
    return trailingSpace
  }
}
