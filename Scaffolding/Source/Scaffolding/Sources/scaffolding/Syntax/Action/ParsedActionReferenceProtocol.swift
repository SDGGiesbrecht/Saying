protocol ParsedActionReferenceProtocol: ParsedSyntaxNodeProtocol {

}

extension ParsedDocumentationReferenceIdentifier: ParsedActionReferenceProtocol {}
extension ParsedAction: ParsedActionReferenceProtocol {}
