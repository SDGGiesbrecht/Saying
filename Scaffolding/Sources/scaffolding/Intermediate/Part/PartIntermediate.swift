struct PartIntermediate {
  var names: Set<UnicodeText>
  var readAccess: AccessIntermediate
  var writeAccess: AccessIntermediate
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
    namespace: [Set<UnicodeText>],
    containerType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> Result<PartIntermediate, ErrorList<PartIntermediate.ConstructionError>> {
    var errors: [PartIntermediate.ConstructionError] = []

    var names: Set<UnicodeText> = []
    for name in declaration.name.names.names {
      names.insert(name.name.identifierText())
    }

    let readAccess = AccessIntermediate(readAccessFrom: declaration.access?.keywords)
    let writeAccess = AccessIntermediate(writeAccessFrom: declaration.access?.keywords)
    let testOnlyAccess = declaration.testAccess?.keyword is ParsedTestsKeyword

    let partNamespace = namespace.appending(names)

    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      switch DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: partNamespace,
        inheritedVisibility: max(readAccess, writeAccess)
      ) {
      case .failure(let nested):
        errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenDocumentation($0) }))
      case .success(let intermediateDocumentation):
        attachedDocumentation = intermediateDocumentation
        for parameter in intermediateDocumentation.parameters.joined() {
          errors.append(ConstructionError.documentedParameterNotFound(parameter))
        }
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
      access: readAccess,
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
        readAccess: readAccess,
        writeAccess: writeAccess,
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
    typeLookup: [UnicodeText: UnicodeText]
  ) -> PartIntermediate {
    return PartIntermediate(
      names: names,
      readAccess: readAccess,
      writeAccess: writeAccess,
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
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>]
  ) -> PartIntermediate {
    return PartIntermediate(
      names: names,
      readAccess: min(readAccess, use.access),
      writeAccess: min(writeAccess, use.access),
      testOnlyAccess: testOnlyAccess || use.testOnlyAccess,
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
        specializationNamespace: specializationNamespace,
        specializationVisibility: use.access
      ),
      declaration: declaration
    )
  }
}
