struct NativeThingImplementationParameter {
  var name: UnicodeText
  var syntaxNode: ParsedUninterruptedIdentifier
  var resolvedType: ParsedTypeReference?
}

extension NativeThingImplementationParameter {
  static func construct(
    _ parameter: ParsedImplementationParameter
  ) -> Result<
    NativeThingImplementationParameter,
    ErrorList<NativeThingImplementationParameter.ConstructionError>
  > {
    var errors: [NativeThingImplementationParameter.ConstructionError] = []

    let name: UnicodeText
    let syntaxNode: ParsedUninterruptedIdentifier
    switch parameter {
    case .simple(let simple):
      name = simple.identifierText()
      syntaxNode = simple
    case .modified(let modified):
      name = modified.parameter.identifierText()
      syntaxNode = modified.parameter
      switch modified.identifierText() {
      default:
        errors.append(.unknownModifier(modified))
      }
    }

    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      NativeThingImplementationParameter(
        name: name,
        syntaxNode: syntaxNode
      )
    )
  }
}

extension NativeThingImplementationParameter {
  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> NativeThingImplementationParameter {
    return NativeThingImplementationParameter(
      name: name,
      syntaxNode: syntaxNode,
      resolvedType: typeLookup[name] ?? resolvedType?.specializing(typeLookup: typeLookup)
    )
  }
}
