protocol ParsedActionReferenceProtocol: ParsedSyntaxNode {
  
}

extension ParsedDocumentationReferenceIdentifier: ParsedActionReferenceProtocol {}
extension ParsedAction: ParsedActionReferenceProtocol {}
