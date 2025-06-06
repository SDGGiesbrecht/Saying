struct RequirementIntermediate {
  fileprivate var prototype: ActionPrototype
  var declaration: ParsedRequirementDeclarationPrototype?

  var documentation: DocumentationIntermediate? {
    return prototype.documentation
  }
  var names: Set<UnicodeText> {
    return prototype.names
  }
  var parameters: Interpolation<ParameterIntermediate> {
    return prototype.parameters
  }
  var returnValue: ParsedTypeReference? {
    return prototype.returnValue
  }
  var access: AccessIntermediate {
    return prototype.access
  }
  var testOnlyAccess: Bool {
    return prototype.testOnlyAccess
  }
  var nativeNames: NativeActionNamesIntermediate {
    return prototype.nativeNames
  }
}

extension RequirementIntermediate {

  static func construct<Declaration>(
    _ declaration: Declaration,
    namespace: [Set<UnicodeText>]
  ) -> Result<RequirementIntermediate, ErrorList<RequirementIntermediate.ConstructionError>>
  where Declaration: ParsedRequirementDeclarationPrototype {
    var errors: [RequirementIntermediate.ConstructionError] = []

    let prototype: ActionPrototype
    switch ActionPrototype.construct(declaration, namespace: namespace) {
    case .failure(let prototypeError):
      errors.append(contentsOf: prototypeError.errors.map({ .brokenPrototype($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      prototype = constructed
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      RequirementIntermediate(
        prototype: prototype,
        declaration: declaration
      )
    )
  }

  func validateReferences(referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    prototype.validateReferences(referenceLookup: referenceLookup, errors: &errors)
  }
}

extension RequirementIntermediate {
  func lookupParameter(_ identifier: UnicodeText) -> ParameterIntermediate? {
    return prototype.lookupParameter(identifier)
  }
}
