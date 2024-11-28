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
    #warning("Only one name?!?")
    names.insert(declaration.name.identifierText())

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
    #warning("Placeholder natives.")
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
