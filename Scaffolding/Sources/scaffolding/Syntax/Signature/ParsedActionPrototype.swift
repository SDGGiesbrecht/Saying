protocol ParsedActionPrototype: ParsedSyntaxNode {
  var access: ParsedAccess? { get }
  var testAccess: ParsedTestAccess? { get }
  var documentation: ParsedAttachedDocumentation? { get }
  var name: ParsedActionName { get }
  var returnValueType: ParsedThingReference? { get }
}

extension ParsedActionDeclaration: ParsedActionPrototype {
  var returnValueType: ParsedThingReference? {
    return returnValue?.type
  }
}
extension ParsedRequirementDeclaration: ParsedActionPrototype {
  var returnValueType: ParsedThingReference? {
    return returnValue?.type
  }
}
extension ParsedChoiceDeclaration: ParsedActionPrototype {
  var returnValueType: ParsedThingReference? {
    return returnValue?.type
  }
}
