import SDGText

struct PartIntermediate {
  var names: Set<StrictString>
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var contents: ParsedTypeReference
  var referenceAction: ActionIntermediate
  var accessor: ActionIntermediate
  var documentation: DocumentationIntermediate?
  var declaration: ParsedPartDeclaration
}

extension PartIntermediate {

  static func construct(
    _ declaration: ParsedPartDeclaration,
    namespace: [Set<StrictString>],
    containerType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> Result<PartIntermediate, ErrorList<PartIntermediate.ConstructionError>> {
    var errors: [PartIntermediate.ConstructionError] = []

    var names: Set<StrictString> = []
    for name in declaration.name.names.names {
      names.insert(StrictString(name.name.identifierText()))
    }

    let access = AccessIntermediate(declaration.access)
    let testOnlyAccess = declaration.testAccess?.keyword is ParsedTestsKeyword

    let partNamespace = namespace.appending(names)

    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      let intermediateDocumentation = DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: partNamespace
      )
      attachedDocumentation = intermediateDocumentation
      for parameter in intermediateDocumentation.parameters.joined() {
        errors.append(ConstructionError.documentedParameterNotFound(parameter))
      }
    }

    let c: NativeActionImplementationIntermediate? = nil
    let cSharp: NativeActionImplementationIntermediate? = nil
    let javaScript: NativeActionImplementationIntermediate? = nil
    let kotlin: NativeActionImplementationIntermediate? = nil
    let swift: NativeActionImplementationIntermediate? = nil

    let contents = ParsedTypeReference(declaration.type)

    let referenceAction = ActionIntermediate.partReference(
      names: names,
      containerType: containerType,
      access: access,
      testOnlyAccess: testOnlyAccess
    )

    let accessor = ActionIntermediate.accessor(
      containerType: containerType,
      partIdentifier: names.identifier(),
      partType: contents,
      access: access,
      testOnlyAccess: testOnlyAccess,
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift
    )

    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      PartIntermediate(
        names: names,
        access: access,
        testOnlyAccess: testOnlyAccess,
        contents: contents,
        referenceAction: referenceAction,
        accessor: accessor,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}

extension PartIntermediate {

  func resolvingExtensionContext(
    typeLookup: [StrictString: UnicodeText]
  ) -> PartIntermediate {
    return PartIntermediate(
      names: names,
      access: access,
      testOnlyAccess: testOnlyAccess,
      contents: contents.resolvingExtensionContext(typeLookup: typeLookup),
      referenceAction: referenceAction.resolvingExtensionContext(typeLookup: typeLookup),
      accessor: accessor.resolvingExtensionContext(typeLookup: typeLookup),
      documentation: documentation?.resolvingExtensionContext(typeLookup: typeLookup),
      declaration: declaration
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> PartIntermediate {
    return PartIntermediate(
      names: names,
      access: access,
      testOnlyAccess: testOnlyAccess,
      contents: contents.specializing(typeLookup: typeLookup),
      referenceAction: referenceAction.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      accessor: accessor.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      documentation: documentation?.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      declaration: declaration
    )
  }
}
