import SDGLogic
import SDGText

struct CaseIntermediate {
  var names: Set<StrictString>
  var constantAction: ActionIntermediate?
  var c: NativeActionImplementationIntermediate?
  var cSharp: NativeActionImplementationIntermediate?
  var javaScript: NativeActionImplementationIntermediate?
  var kotlin: NativeActionImplementationIntermediate?
  var swift: NativeActionImplementationIntermediate?
  var documentation: DocumentationIntermediate?
  var declaration: ParsedCaseDeclaration
}

extension CaseIntermediate {

  static func disallowImports(
    in implementation: ParsedNativeActionImplementation,
    errors: inout [ConstructionError]
  ) {
    if implementation.expression.importNode ≠ nil {
      errors.append(ConstructionError.invalidImport(implementation))
    }
  }

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

    var c: NativeActionImplementationIntermediate?
    var cSharp: NativeActionImplementationIntermediate?
    var javaScript: NativeActionImplementationIntermediate?
    var kotlin: NativeActionImplementationIntermediate?
    var swift: NativeActionImplementationIntermediate?
    if let native = declaration.implementation {
      for implementation in native.implementations.implementations {
        switch NativeActionImplementationIntermediate.construct(
          implementation: implementation.expression
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeCaseImplementation($0) }))
        case .success(let constructed):
          switch implementation.language.identifierText() {
          case "C":
            c = constructed
          case "C♯":
            cSharp = constructed
            disallowImports(in: implementation, errors: &errors)
          case "JavaScript":
            javaScript = constructed
            disallowImports(in: implementation, errors: &errors)
          case "Kotlin":
            kotlin = constructed
            disallowImports(in: implementation, errors: &errors)
          case "Swift":
            swift = constructed
            disallowImports(in: implementation, errors: &errors)
          default:
            errors.append(ConstructionError.unknownLanguage(implementation.language))
          }
        }
      }
    }

    let constantAction: ActionIntermediate? = declaration.contents == nil
      ? ActionIntermediate.enumerationAction(
        names: names,
        returnValue: type,
        access: access,
        testOnlyAccess: testOnlyAccess,
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift
      )
      : nil

    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      CaseIntermediate(
        names: names,
        constantAction: constantAction,
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift,
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
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift,
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
