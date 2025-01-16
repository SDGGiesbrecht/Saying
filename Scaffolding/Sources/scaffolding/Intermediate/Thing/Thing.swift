import SDGText

struct Thing {
  var names: Set<StrictString>
  var parameters: Interpolation<ThingParameterIntermediate>
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var cases: [CaseIntermediate]
  var c: NativeThingImplementationIntermediate?
  var cSharp: NativeThingImplementationIntermediate?
  var kotlin: NativeThingImplementationIntermediate?
  var swift: NativeThingImplementationIntermediate?
  var documentation: DocumentationIntermediate?
  var declaration: ParsedThingDeclarationProtocol
  var swiftName: StrictString?
}

extension Thing {
  var isSimple: Bool {
    return cases.allSatisfy({ $0.contents == nil })
  }
}

extension Thing {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    if parameters.inAnyOrder.isEmpty {
      return [self.names.identifier()]
    } else {
      let simple = names.identifier()
      var result: [StrictString] = ["("]
      result.append(simple)
      result.append(contentsOf: parameters.ordered(for: simple)
        .lazy.flatMap({ $0.resolvedType!.unresolvedGloballyUniqueIdentifierComponents() }))
      result.append(")")
      return result
    }
  }

  func resolve(
    globallyUniqueIdentifierComponents: [StrictString],
    referenceLookup: [ReferenceDictionary]
  ) -> StrictString {
    return globallyUniqueIdentifierComponents
        .lazy.map({ referenceLookup.resolve(identifier: $0) })
        .joined(separator: ":")
  }

  func globallyUniqueIdentifier(referenceLookup: [ReferenceDictionary]) -> StrictString {
    return resolve(
      globallyUniqueIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      referenceLookup: referenceLookup
    )
  }
}

extension Thing {

  static func disallowImports(
    in implementation: ParsedNativeThingImplementation,
    errors: inout [ConstructionError]
  ) {
    if implementation.implementation.importNode != nil {
      errors.append(ConstructionError.invalidImport(implementation))
    }
  }

  static func construct<ThingNode>(
    _ declaration: ThingNode,
    namespace: [Set<StrictString>]
  ) -> Result<Thing, ErrorList<Thing.ConstructionError>>
  where ThingNode: ParsedThingDeclarationProtocol {
    var errors: [Thing.ConstructionError] = []
    let namesDictionary = declaration.name.namesDictionary
    let parameters: Interpolation<ThingParameterIntermediate>
    switch Interpolation.construct(
      entries: namesDictionary.values,
      getEntryName: { $0.name() },
      getParameters: { $0.parameters?.parameters ?? [] },
      getParameterName: { $0.name.identifierText() },
      getDefinitionOrReference: { $0.definitionOrReference },
      getNestedSignature: { _ in nil },
      getNestedParameters: { _ in [] },
      constructParameter: { names, _, _ in ThingParameterIntermediate(names: names) }
    ) {
    case .failure(let interpolationError):
      errors.append(contentsOf: interpolationError.errors.map({ .brokenParameterInterpolation($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      parameters = constructed
    }
    var names: Set<StrictString> = []
    var swiftName: StrictString?
    for (language, signature) in namesDictionary {
      let name = signature.name()
      if language == "Swift" {
        swiftName = name
      }
      names.insert(name)
    }

    let thingNamespace = namespace.appending(names)
    let selfReference = declaration.name.names.names
      .lazy.compactMap({ ParsedTypeReference($0.name) })
      .first!
    let access = AccessIntermediate(declaration.access)
    let testOnlyAccess = declaration.testAccess?.keyword is ParsedTestsKeyword

    var cases: [CaseIntermediate] = []
    for enumerationCase in declaration.enumerationCases {
      switch CaseIntermediate.construct(
        enumerationCase,
        namespace: thingNamespace,
        type: selfReference,
        access: access,
        testOnlyAccess: testOnlyAccess
      ) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ .brokenCaseImplementation($0) }))
      case .success(let constructed):
        cases.append(constructed)
      }
    }

    var c: NativeThingImplementationIntermediate?
    var cSharp: NativeThingImplementationIntermediate?
    var kotlin: NativeThingImplementationIntermediate?
    var swift: NativeThingImplementationIntermediate?
    for implementation in declaration.nativeImplementations {
      let constructed: NativeThingImplementationIntermediate
      switch NativeThingImplementationIntermediate.construct(implementation: implementation.implementation) {
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
      let intermediateDocumentation = DocumentationIntermediate.construct(documentation.documentation, namespace: thingNamespace)
      attachedDocumentation = intermediateDocumentation
      for parameter in intermediateDocumentation.parameters.joined() {
        errors.append(ConstructionError.documentedParameterNotFound(parameter))
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Thing(
        names: names,
        parameters: parameters,
        access: access,
        testOnlyAccess: testOnlyAccess,
        cases: cases,
        c: c,
        cSharp: cSharp,
        kotlin: kotlin,
        swift: swift,
        documentation: attachedDocumentation,
        declaration: declaration,
        swiftName: swiftName
      )
    )
  }
}

extension Thing {

  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> Thing {
    let mappedParameters = parameters.mappingParameters({ parameter in
      let identifier = parameter.names
        .lazy.compactMap({ typeLookup[$0] })
        .first!
      return ThingParameterIntermediate(names: [identifier])
    })
    return Thing(
      names: names,
      parameters: mappedParameters,
      access: access,
      testOnlyAccess: testOnlyAccess,
      cases: cases.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
      c: c?.resolvingExtensionContext(typeLookup: typeLookup),
      cSharp: cSharp?.resolvingExtensionContext(typeLookup: typeLookup),
      kotlin: kotlin?.resolvingExtensionContext(typeLookup: typeLookup),
      swift: swift?.resolvingExtensionContext(typeLookup: typeLookup),
      documentation: documentation,
      declaration: declaration,
      swiftName: swiftName
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> Thing {
    let mappedParameters = parameters.mappingParameters { $0.specializing(typeLookup: typeLookup) }
    let newCases = cases.map({ enumerationCase in
      return enumerationCase.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    return Thing(
      names: names,
      parameters: mappedParameters,
      access: access,
      testOnlyAccess: testOnlyAccess,
      cases: newCases,
      c: c?.specializing(typeLookup: typeLookup),
      cSharp: cSharp?.specializing(typeLookup: typeLookup),
      kotlin: kotlin?.specializing(typeLookup: typeLookup),
      swift: swift?.specializing(typeLookup: typeLookup),
      documentation: newDocumentation,
      declaration: declaration,
      swiftName: swiftName
    )
  }
}
