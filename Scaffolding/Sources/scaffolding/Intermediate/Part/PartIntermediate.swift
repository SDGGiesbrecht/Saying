import SDGText

struct PartIntermediate {
  var names: Set<StrictString>
  var contents: ParsedTypeReference
  var documentation: DocumentationIntermediate?
  var declaration: ParsedPartDeclaration
}

extension PartIntermediate {

  static func construct(
    _ declaration: ParsedPartDeclaration,
    namespace: [Set<StrictString>],
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> Result<PartIntermediate, ErrorList<PartIntermediate.ConstructionError>> {
    var errors: [PartIntermediate.ConstructionError] = []

    var names: Set<StrictString> = []
    for name in declaration.name.names.names {
      names.insert(name.name.identifierText())
    }

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

    let contents = ParsedTypeReference(declaration.type)

    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      PartIntermediate(
        names: names,
        contents: contents,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}

extension PartIntermediate {

  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> PartIntermediate {
    return PartIntermediate(
      names: names,
      contents: contents.resolvingExtensionContext(typeLookup: typeLookup),
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
      contents: contents.specializing(typeLookup: typeLookup),
      documentation: documentation?.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      declaration: declaration
    )
  }
}
