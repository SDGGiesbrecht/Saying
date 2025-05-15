import SDGText

struct Thing {
  var names: Set<StrictString>
  var parameters: Interpolation<ThingParameterIntermediate>
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var parts: [PartIntermediate]
  var cases: [CaseIntermediate]
  var c: NativeThingImplementationIntermediate?
  var cSharp: NativeThingImplementationIntermediate?
  var kotlin: NativeThingImplementationIntermediate?
  var swift: NativeThingImplementationIntermediate?
  var documentation: DocumentationIntermediate?
  var declaration: ParsedThingDeclarationProtocol
  var swiftName: UnicodeText?

  func allNativeImplementations() -> [NativeThingImplementationIntermediate] {
    return [c, cSharp, kotlin, swift].compactMap({ $0 })
  }
}

extension Thing {
  var isSimple: Bool {
    return cases.allSatisfy({ $0.contents == nil })
  }
}

extension Thing {
  func reference(resolvingFromReferenceLookup referenceLookup: [ReferenceDictionary]) -> TypeReference {
    let identifier = StrictString(names.identifier())
    let parameters = parameters.ordered(for: names.identifier())
    let result: TypeReference
    if parameters.isEmpty {
      result = .simple(identifier)
    } else {
      result = .compound(identifier: identifier, components: parameters.map({ $0.resolvedType!.key }))
    }
    return result.resolving(fromReferenceLookup: referenceLookup)
  }
}

extension Thing {
  func unresolvedGloballyUniqueIdentifierComponents() -> [UnicodeText] {
    if parameters.inAnyOrder.isEmpty {
      return [self.names.identifier()]
    } else {
      let simple = names.identifier()
      var result: [UnicodeText] = ["("].map({ UnicodeText($0) })
      result.append(simple)
      result.append(contentsOf: parameters.ordered(for: simple)
        .lazy.flatMap({ $0.resolvedType!.unresolvedGloballyUniqueIdentifierComponents() }))
      result.append(UnicodeText(")"))
      return result
    }
  }

  func resolve(
    globallyUniqueIdentifierComponents: [UnicodeText],
    referenceLookup: [ReferenceDictionary]
  ) -> UnicodeText {
    return UnicodeText(
      globallyUniqueIdentifierComponents
        .lazy.map({ StrictString(referenceLookup.resolve(identifier: $0)) })
        .joined(separator: ":")
      )
  }

  func globallyUniqueIdentifier(referenceLookup: [ReferenceDictionary]) -> UnicodeText {
    return resolve(
      globallyUniqueIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      referenceLookup: referenceLookup
    )
  }
}

extension Thing {

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
    var swiftName: UnicodeText?
    for (language, signature) in namesDictionary {
      let name = signature.name()
      if language == "Swift" {
        swiftName = name
      }
      names.insert(StrictString(name))
    }

    let thingNamespace = namespace.appending(names)
    let selfReference = declaration.name.names.names
      .lazy.compactMap({ ParsedTypeReference($0.name) })
      .first!
    let access = AccessIntermediate(declaration.access)
    let testOnlyAccess = declaration.testAccess?.keyword is ParsedTestsKeyword

    var parts: [PartIntermediate] = []
    for part in declaration.parts {
      switch PartIntermediate.construct(
        part,
        namespace: thingNamespace,
        containerType: selfReference,
        access: access,
        testOnlyAccess: testOnlyAccess
      ) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ .brokenPartImplementation($0) }))
      case .success(let constructed):
        parts.append(constructed)
      }
    }

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
      switch StrictString(implementation.language.identifierText()) {
      case "C":
        c = constructed
      case "C♯":
        cSharp = constructed
      case "Kotlin":
        kotlin = constructed
      case "Swift":
        swift = constructed
      default:
        errors.append(ConstructionError.unknownLanguage(implementation.language))
      }
    }
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      switch DocumentationIntermediate.construct(documentation.documentation, namespace: thingNamespace) {
      case .failure(let nested):
        errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenDocumentation($0) }))
      case .success(let intermediateDocumentation):
        attachedDocumentation = intermediateDocumentation
        for parameter in intermediateDocumentation.parameters.joined() {
          errors.append(ConstructionError.documentedParameterNotFound(parameter))
        }
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
        parts: parts,
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
  func validateReferences(referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    for native in allNativeImplementations() {
      for parameterReference in [native.parameters]
        .appending(contentsOf: native.indirectRequirements.compactMap({ $0.parameters }))
        .appending(contentsOf: native.requiredDeclarations.compactMap({ $0.parameters }))
        .joined() {
        if let typeInstead = parameterReference.resolvedType {
          typeInstead.validateReferences(
            requiredAccess: access,
            allowTestOnlyAccess: testOnlyAccess,
            referenceLookup: referenceLookup,
            errors: &errors
          )
        } else {
          if parameters.parameter(named: parameterReference.name) == nil {
            errors.append(.noSuchParameter(parameterReference.syntaxNode))
          }
        }
      }
    }
    documentation?.validateReferences(
      referenceLookup: referenceLookup,
      errors: &errors
    )
  }
}

extension Thing {

  func resolvingExtensionContext(
    typeLookup: [StrictString: UnicodeText]
  ) -> Thing {
    let mappedParameters = parameters.mappingParameters({ parameter in
      let identifier = parameter.names
        .lazy.compactMap({ typeLookup[$0] })
        .first!
      return ThingParameterIntermediate(names: [StrictString(identifier)])
    })
    return Thing(
      names: names,
      parameters: mappedParameters,
      access: access,
      testOnlyAccess: testOnlyAccess,
      parts: parts.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
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
    let newParts = parts.map({ part in
      return part.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
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
      parts: newParts,
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

extension Thing {

  func requiredIdentifiers<P>(
    moduleAndExternalReferenceLookup: [ReferenceDictionary],
    platform: P.Type
  ) -> [UnicodeText]
  where P: Platform {
    var result: [UnicodeText] = []
    for part in parts {
      result.append(
        contentsOf: part.contents.requiredIdentifiers(
          moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
        )
      )
    }
    if let native = platform.nativeType(of: self) {
      for indirectRequirement in native.indirectRequirements {
        result.append(
          UnicodeText(
            StrictString(
              platform.source(for: indirectRequirement, referenceLookup: moduleAndExternalReferenceLookup)
            )
          )
        )
      }
    }
    return result
  }
}
