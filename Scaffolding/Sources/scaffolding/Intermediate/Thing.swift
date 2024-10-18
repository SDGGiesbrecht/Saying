import SDGLogic
import SDGText

struct Thing {
  var names: Set<StrictString>
  var clientAccess: Bool
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

    let names: Set<StrictString> = Set(
      declaration.name.names.names
        .lazy.map({ $0.name.identifierText() })
    )

    var c: NativeThingImplementation?
    var cSharp: NativeThingImplementation?
    var kotlin: NativeThingImplementation?
    var swift: NativeThingImplementation?
    for implementation in declaration.implementation.implementations {
      let constructed = NativeThingImplementation.construct(implementation: implementation.implementation)
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
      for parameter in intermediateDocumentation.parameters {
        errors.append(ConstructionError.documentedParameterNotFound(parameter))
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Thing(
        names: names,
        clientAccess: declaration.access?.keyword is ParsedClientsKeyword,
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
