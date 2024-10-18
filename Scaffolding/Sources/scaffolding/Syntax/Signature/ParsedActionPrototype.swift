protocol ParsedActionPrototype: ParsedSyntaxNode {
  var access: ParsedAccess? { get }
  var testAccess: ParsedTestAccess? { get }
  var documentation: ParsedAttachedDocumentation? { get }
  var name: ParsedActionName { get }
  var returnValueType: ParsedUninterruptedIdentifier? { get }
}

extension ParsedActionDeclaration: ParsedActionPrototype {
  var returnValueType: ParsedUninterruptedIdentifier? {
    return returnValue?.type
  }
}
extension ParsedRequirementDeclaration: ParsedActionPrototype {
  var returnValueType: ParsedUninterruptedIdentifier? {
    return returnValue?.type
  }
}
