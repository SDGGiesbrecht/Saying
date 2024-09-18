struct DiagnosticParseResult<ParsedNode>
where ParsedNode: ParsableSyntaxNode {
  var result: ParsedNode
  var reasonsNotContinued: ErrorList<ParsedNode.ParseError>
}
