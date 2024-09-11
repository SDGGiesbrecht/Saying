extension ActionIntermediate {
  enum ConstructionError: Error {
    case referenceInTypeSignature(ParsedParameter)
    case typeInReferenceSignature(ParsedParameter)
    case multipleTypeSignatures(ParsedSignature)
    case cyclicalParameterReference(ParsedParameter)
    case parameterNotFound(ParsedParameterReference)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenCSharpScriptImplementation(CSharpImplementation.ConstructionError)
    case brokenJavaScriptImplementation(JavaScriptImplementation.ConstructionError)
    case brokenSwiftImplementation(SwiftImplementation.ConstructionError)
  }
}
