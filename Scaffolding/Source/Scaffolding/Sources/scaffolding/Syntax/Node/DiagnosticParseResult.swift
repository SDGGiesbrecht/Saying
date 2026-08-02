struct DiagnosticParseResult<ParsedNode>
where ParsedNode: ParsableSyntaxNode {
  var result: ParsedNode
  var reasonNotContinued: ParsedNode.ParseError?
}
