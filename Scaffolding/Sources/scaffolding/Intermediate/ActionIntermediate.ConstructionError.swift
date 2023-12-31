extension ActionIntermediate {
  enum ConstructionError: Error {
    case referenceInTypeSignature(ParsedParameter)
    case typeInReferenceSignature(ParsedParameter)
    case multipleTypeSignatures(ParsedSignature)
    case cyclicalParameterReference(ParsedParameter)
    case parameterNotFound(ParsedParameterReference)
    case unknownLanguage(ParsedUninterruptedIdentifier)
    case brokenJavaScriptImplementation(JavaScriptImplementation.ConstructionError)
    case brokenSwiftImplementation(SwiftImplementation.ConstructionError)
  }
}
