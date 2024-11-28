protocol ParsedThingDeclarationProtocol: ParsedSyntaxNode {
  var documentation: ParsedAttachedDocumentation? { get }
  var access: ParsedAccess? { get }
  var testAccess: ParsedTestAccess? { get }
  var name: ParsedThingName { get }
  var nativeImplementations: [ParsedThingImplementation] { get }
  var enumerationCases: [ParsedCaseDeclaration] { get }
  var genericDeclaration: ParsedDeclaration { get }
}

extension ParsedThingDeclaration: ParsedThingDeclarationProtocol {
  var nativeImplementations: [ParsedThingImplementation] {
    return implementation.implementations
  }
  var enumerationCases: [ParsedCaseDeclaration] {
    return []
  }
  var genericDeclaration: ParsedDeclaration {
    return .thing(self)
  }
}
extension ParsedEnumerationDeclaration: ParsedThingDeclarationProtocol {
  var nativeImplementations: [ParsedThingImplementation] {
    return []
  }
  var enumerationCases: [ParsedCaseDeclaration] {
    return cases.cases.cases.cases
  }
  var genericDeclaration: ParsedDeclaration {
    return .enumeration(self)
  }
}
