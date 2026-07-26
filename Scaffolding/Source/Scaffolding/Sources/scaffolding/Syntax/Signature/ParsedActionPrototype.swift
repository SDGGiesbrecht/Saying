protocol ParsedActionPrototype: ParsedSyntaxNode {
  var isFlow: Bool { get }
  var access: ParsedAccess? { get }
  var testAccess: ParsedTestAccess? { get }
  var documentation: ParsedAttachedDocumentation? { get }
  var name: ParsedActionName { get }
  var returnValueType: ParsedThingReference? { get }
}

extension ParsedActionDeclaration: ParsedActionPrototype {
  var isFlow: Bool {
    switch keyword {
    case .action:
      return false
    case .flow:
      return true
    }
  }
  var returnValueType: ParsedThingReference? {
    return returnValue?.type
  }
}
extension ParsedRequirementDeclaration: ParsedActionPrototype {
  var isFlow: Bool {
    return false
  }
  var returnValueType: ParsedThingReference? {
    return returnValue?.type
  }
}
extension ParsedChoiceDeclaration: ParsedActionPrototype {
  var isFlow: Bool {
    return false
  }
  var returnValueType: ParsedThingReference? {
    return returnValue?.type
  }
}
