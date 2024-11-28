import SDGLogic
import SDGText

struct CaseIntermediate {
  var names: Set<StrictString>
  var constantAction: ActionIntermediate?
  var c: NativeThingImplementation?
  var cSharp: NativeThingImplementation?
  var javaScript: NativeThingImplementation?
  var kotlin: NativeThingImplementation?
  var swift: NativeThingImplementation?
  var documentation: DocumentationIntermediate?
  var declaration: ParsedCaseDeclaration
}

extension CaseIntermediate {
  static func construct(
    _ declaration: ParsedCaseDeclaration,
    namespace: [Set<StrictString>],
    type: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> Result<CaseIntermediate, ErrorList<CaseIntermediate.ConstructionError>> {
    var errors: [CaseIntermediate.ConstructionError] = []

    var names: Set<StrictString> = []
    for name in declaration.name.names.names {
      names.insert(name.name.identifierText())
    }

    let caseNamespace = namespace.appending(names)

    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      let intermediateDocumentation = DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: caseNamespace
      )
      attachedDocumentation = intermediateDocumentation
      for parameter in intermediateDocumentation.parameters.joined() {
        errors.append(ConstructionError.documentedParameterNotFound(parameter))
      }
    }

    let constantAction: ActionIntermediate? = declaration.contents == nil
      ? ActionIntermediate.enumerationAction(
        names: names,
        returnValue: type,
        access: access,
        testOnlyAccess: testOnlyAccess
      )
      : nil

    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      CaseIntermediate(
        names: names,
        constantAction: constantAction,
        c: nil,
        cSharp: nil,
        javaScript: nil,
        kotlin: nil,
        swift: nil,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}

extension CaseIntermediate {

  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> CaseIntermediate {
    return CaseIntermediate(
      names: names,
      constantAction: constantAction?.resolvingExtensionContext(typeLookup: typeLookup),
      c: c?.resolvingExtensionContext(typeLookup: typeLookup),
      cSharp: cSharp?.resolvingExtensionContext(typeLookup: typeLookup),
      javaScript: javaScript?.resolvingExtensionContext(typeLookup: typeLookup),
      kotlin: kotlin?.resolvingExtensionContext(typeLookup: typeLookup),
      swift: swift?.resolvingExtensionContext(typeLookup: typeLookup),
      documentation: documentation?.resolvingExtensionContext(typeLookup: typeLookup),
      declaration: declaration
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> CaseIntermediate {
    return CaseIntermediate(
      names: names,
      constantAction: constantAction?.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      c: c?.specializing(typeLookup: typeLookup),
      cSharp: cSharp?.specializing(typeLookup: typeLookup),
      javaScript: javaScript?.specializing(typeLookup: typeLookup),
      kotlin: kotlin?.specializing(typeLookup: typeLookup),
      swift: swift?.specializing(typeLookup: typeLookup),
      documentation: documentation?.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      declaration: declaration
    )
  }
}
