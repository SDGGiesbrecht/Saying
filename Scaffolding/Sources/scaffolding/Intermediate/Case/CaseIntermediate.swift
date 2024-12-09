import SDGLogic
import SDGText

struct CaseIntermediate {
  var names: Set<StrictString>
  var contents: ParsedTypeReference?
  var referenceAction: ActionIntermediate?
  var wrapAction: ActionIntermediate?
  var unwrapAction: ActionIntermediate?
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

    let contents = (declaration.contents?.type).map({ ParsedTypeReference($0) })

    let referenceAction: ActionIntermediate? = contents == nil
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
      : ActionIntermediate.enumerationCase(
        names: names,
        enumerationType: type,
        access: access,
        testOnlyAccess: testOnlyAccess
      )
    let wrapAction: ActionIntermediate? = contents == nil
      ? nil
      : nil
    let unwrapAction: ActionIntermediate? = contents.map({ valueType in
      ActionIntermediate.enumerationUnwrap(
        enumerationType: type,
        caseIdentifier: names.identifier(),
        valueType: valueType,
        access: access,
        testOnlyAccess: testOnlyAccess
      )
    })

    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      CaseIntermediate(
        names: names,
        contents: contents,
        referenceAction: referenceAction,
        wrapAction: wrapAction,
        unwrapAction: unwrapAction,
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
      contents: contents?.resolvingExtensionContext(typeLookup: typeLookup),
      referenceAction: referenceAction?.resolvingExtensionContext(typeLookup: typeLookup),
      wrapAction: wrapAction?.resolvingExtensionContext(typeLookup: typeLookup),
      unwrapAction: unwrapAction?.resolvingExtensionContext(typeLookup: typeLookup),
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
      contents: contents?.specializing(typeLookup: typeLookup),
      referenceAction: referenceAction?.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      wrapAction: wrapAction?.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      unwrapAction: unwrapAction?.specializing(
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
