protocol ParsedThingDeclarationProtocol: ParsedSyntaxNode {
  var documentation: ParsedAttachedDocumentation? { get }
  var access: ParsedAccess? { get }
  var testAccess: ParsedTestAccess? { get }
  var name: ParsedThingName { get }
  var nativeImplementations: [ParsedNativeThingImplementation] { get }
  var enumerationCases: [ParsedCaseDeclaration] { get }
  var genericDeclaration: ParsedDeclaration { get }
}

extension ParsedThingDeclaration: ParsedThingDeclarationProtocol {
  var nativeImplementations: [ParsedNativeThingImplementation] {
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
  var nativeImplementations: [ParsedNativeThingImplementation] {
    return []
  }
  var enumerationCases: [ParsedCaseDeclaration] {
    switch implementation {
    case .source(let cases):
      return cases.cases.cases.cases
    case .dual(let dual):
      return dual.source.cases.cases.cases
    }
  }
  var genericDeclaration: ParsedDeclaration {
    return .enumeration(self)
  }
}
