public struct DiagnosticParseResult<ParsedNode>
where ParsedNode: ParsableSyntaxNode {
  public var result: ParsedNode
  public var reasonNotContinued: ParsedNode.ParseError?
}
