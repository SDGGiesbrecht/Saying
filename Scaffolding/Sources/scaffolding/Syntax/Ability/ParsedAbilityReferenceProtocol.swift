protocol ParsedAbilityReferenceProtocol: ParsedSyntaxNode {
  
}

extension ParsedUseSignature: ParsedAbilityReferenceProtocol {}
extension ParsedAbilitySignature: ParsedAbilityReferenceProtocol {}
