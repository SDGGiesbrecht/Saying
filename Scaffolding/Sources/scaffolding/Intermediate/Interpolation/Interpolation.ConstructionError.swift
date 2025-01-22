extension Interpolation {
  enum ConstructionError: DiagnosticError {
    case multipleParameterDefinitionSets(ParsedSyntaxNode)
    case definitionInReferenceSet(ParsedSyntaxNode)
    case referenceInDefinitionSet(ParsedSyntaxNode)
    case cyclicalParameterReference(ParsedSyntaxNode)
    case parameterNotFound(ParsedParameterReference)
    case rearrangedParameters(ParsedSyntaxNode)

    var range: Slice<UnicodeSegments> {
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
