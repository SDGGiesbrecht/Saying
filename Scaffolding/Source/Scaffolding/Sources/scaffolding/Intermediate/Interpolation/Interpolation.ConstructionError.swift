import Saying

extension Interpolation {
  enum ConstructionError: DiagnosticError {
    case multipleParameterDefinitionSets(ParsedSyntaxNodeProtocol)
    case definitionInReferenceSet(ParsedSyntaxNodeProtocol)
    case referenceInDefinitionSet(ParsedSyntaxNodeProtocol)
    case cyclicalParameterReference(ParsedSyntaxNodeProtocol)
    case parameterNotFound(ParsedParameterReference)
    case rearrangedParameters(ParsedSyntaxNodeProtocol)

    var range: SayingSourceSlice {
      switch self {
      case .multipleParameterDefinitionSets(let definition):
        return definition.location
      case .definitionInReferenceSet(let definition):
        return definition.location
      case .referenceInDefinitionSet(let reference):
        return reference.location
      case .cyclicalParameterReference(let parameter):
        return parameter.location
      case .parameterNotFound(let reference):
        return reference.location
      case .rearrangedParameters(let signature):
        return signature.location
      }
    }
  }
}
