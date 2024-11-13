import SDGLogic
import SDGText

struct Thing {
  var names: Set<StrictString>
  var parameters: Interpolation<AbilityParameterIntermediate>
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var c: NativeThingImplementation?
  var cSharp: NativeThingImplementation?
  var kotlin: NativeThingImplementation?
  var swift: NativeThingImplementation?
  var documentation: DocumentationIntermediate?
  var declaration: ParsedThingDeclaration
}

extension Thing {

  static func disallowImports(
    in implementation: ParsedThingImplementation,
    errors: inout [ConstructionError]
  ) {
    if implementation.implementation.importNode ≠ nil {
      errors.append(ConstructionError.invalidImport(implementation))
    }
  }

  static func construct(
    _ declaration: ParsedThingDeclaration,
    namespace: [Set<StrictString>]
  ) -> Result<Thing, ErrorList<Thing.ConstructionError>> {
    var errors: [Thing.ConstructionError] = []

    let namesSyntax = declaration.name.names.names
    let parameters: Interpolation<AbilityParameterIntermediate>
    switch Interpolation.construct(
      entries: declaration.name.names.names,
      getEntryName: { $0.name.name() },
      getParameters: { $0.name.parameters?.parameters ?? [] },
      getParameterName: { $0.name.identifierText() },
      getDefinitionOrReference: { $0.definitionOrReference },
      getNestedSignature: { _ in nil },
      getNestedParameters: { _ in [] },
      constructParameter: { names, _, _ in AbilityParameterIntermediate(names: names) }
    ) {
    case .failure(let interpolationError):
      errors.append(contentsOf: interpolationError.errors.map({ .brokenParameterInterpolation($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      parameters = constructed
    }
    var names: Set<StrictString> = []
    for name in namesSyntax {
      names.insert(name.name.name())
    }

    var c: NativeThingImplementation?
    var cSharp: NativeThingImplementation?
    var kotlin: NativeThingImplementation?
    var swift: NativeThingImplementation?
    for implementation in declaration.implementation.implementations {
      let constructed: NativeThingImplementation
      switch NativeThingImplementation.construct(implementation: implementation.implementation) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ .brokenNativeImplementation($0) }))
        continue
      case .success(let result):
        constructed = result
      }
      switch implementation.language.identifierText() {
      case "C":
        c = constructed
      case "C♯":
        disallowImports(in: implementation, errors: &errors)
        cSharp = constructed
      case "Kotlin":
        disallowImports(in: implementation, errors: &errors)
        kotlin = constructed
      case "Swift":
        disallowImports(in: implementation, errors: &errors)
        swift = constructed
      default:
        errors.append(ConstructionError.unknownLanguage(implementation.language))
      }
    }
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      let intermediateDocumentation = DocumentationIntermediate.construct(documentation.documentation, namespace: namespace.appending(names))
      attachedDocumentation = intermediateDocumentation
      for parameter in intermediateDocumentation.parameters.joined() {
        errors.append(ConstructionError.documentedParameterNotFound(parameter))
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Thing(
        names: names,
        parameters: parameters,
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        c: c,
        cSharp: cSharp,
        kotlin: kotlin,
        swift: swift,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}

extension Thing {

  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> Thing {
    let mappedParameters = parameters.mappingParameters({ parameter in
      let identifier = parameter.names.identifier()
      return AbilityParameterIntermediate(names: [typeLookup[identifier]!])
    })
    return Thing(
      names: names,
      parameters: mappedParameters,
      access: access,
      testOnlyAccess: testOnlyAccess,
      c: c?.resolvingExtensionContext(typeLookup: typeLookup),
      cSharp: cSharp?.resolvingExtensionContext(typeLookup: typeLookup),
      kotlin: kotlin?.resolvingExtensionContext(typeLookup: typeLookup),
      swift: swift?.resolvingExtensionContext(typeLookup: typeLookup),
      documentation: documentation,
      declaration: declaration
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> Thing {
    #warning("Not implemented yet.")
    print("Thing not actually specializing. (Also not sure all parameters are necessary.)")
    return self
  }
}
