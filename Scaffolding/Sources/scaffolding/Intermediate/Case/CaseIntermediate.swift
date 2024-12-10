import SDGLogic
import SDGText

struct CaseIntermediate {
  var names: Set<StrictString>
  var contents: ParsedTypeReference?
  var referenceAction: ActionIntermediate?
  var wrapAction: ActionIntermediate?
  var unwrapAction: ActionIntermediate?
  var cStore: NativeActionImplementationIntermediate?
  var cSharpStore: NativeActionImplementationIntermediate?
  var javaScriptStore: NativeActionImplementationIntermediate?
  var kotlinStore: NativeActionImplementationIntermediate?
  var swiftStore: NativeActionImplementationIntermediate?
  var cRetrieve: NativeActionImplementationIntermediate?
  var cSharpRetrieve: NativeActionImplementationIntermediate?
  var javaScriptRetrieve: NativeActionImplementationIntermediate?
  var kotlinRetrieve: NativeActionImplementationIntermediate?
  var swiftRetrieve: NativeActionImplementationIntermediate?
  var documentation: DocumentationIntermediate?
  var declaration: ParsedCaseDeclaration
}

extension CaseIntermediate {

  static func disallowImports(
    in implementation: ParsedNativeAction,
    errors: inout [ConstructionError]
  ) {
    if implementation.importNode ≠ nil {
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

    var cStore: NativeActionImplementationIntermediate?
    var cSharpStore: NativeActionImplementationIntermediate?
    var javaScriptStore: NativeActionImplementationIntermediate?
    var kotlinStore: NativeActionImplementationIntermediate?
    var swiftStore: NativeActionImplementationIntermediate?
    var cRetrieve: NativeActionImplementationIntermediate?
    var cSharpRetrieve: NativeActionImplementationIntermediate?
    var javaScriptRetrieve: NativeActionImplementationIntermediate?
    var kotlinRetrieve: NativeActionImplementationIntermediate?
    var swiftRetrieve: NativeActionImplementationIntermediate?
    if let details = declaration.details {
      switch details {
      case .contents:
        break
      case .implementation(let implementations):
        for implementation in implementations.implementations.implementations {
          switch NativeActionImplementationIntermediate.construct(
            implementation: implementation.expression
          ) {
          case .failure(let error):
            errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeCaseImplementation($0) }))
          case .success(let constructed):
            switch implementation.language.identifierText() {
            case "C":
              cStore = constructed
            case "C♯":
              cSharpStore = constructed
              disallowImports(in: implementation.expression, errors: &errors)
            case "JavaScript":
              javaScriptStore = constructed
              disallowImports(in: implementation.expression, errors: &errors)
            case "Kotlin":
              kotlinStore = constructed
              disallowImports(in: implementation.expression, errors: &errors)
            case "Swift":
              swiftStore = constructed
              disallowImports(in: implementation.expression, errors: &errors)
            default:
              errors.append(ConstructionError.unknownLanguage(implementation.language))
            }
          }
        }
      case .dual(let details):
        for implementation in details.implementation.implementations.implementations {
          switch NativeActionImplementationIntermediate.construct(
            implementation: implementation.expressions.store
          ) {
          case .failure(let error):
            errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeCaseImplementation($0) }))
          case .success(let constructed):
            switch implementation.language.identifierText() {
            case "C":
              cStore = constructed
            case "C♯":
              cSharpStore = constructed
              disallowImports(in: implementation.expressions.store, errors: &errors)
            case "JavaScript":
              javaScriptStore = constructed
              disallowImports(in: implementation.expressions.store, errors: &errors)
            case "Kotlin":
              kotlinStore = constructed
              disallowImports(in: implementation.expressions.store, errors: &errors)
            case "Swift":
              swiftStore = constructed
              disallowImports(in: implementation.expressions.store, errors: &errors)
            default:
              errors.append(ConstructionError.unknownLanguage(implementation.language))
            }
          }
          switch NativeActionImplementationIntermediate.construct(
            implementation: implementation.expressions.retrieve
          ) {
          case .failure(let error):
            errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeCaseImplementation($0) }))
          case .success(let constructed):
            switch implementation.language.identifierText() {
            case "C":
              cRetrieve = constructed
            case "C♯":
              cSharpRetrieve = constructed
              disallowImports(in: implementation.expressions.retrieve, errors: &errors)
            case "JavaScript":
              javaScriptRetrieve = constructed
              disallowImports(in: implementation.expressions.retrieve, errors: &errors)
            case "Kotlin":
              kotlinRetrieve = constructed
              disallowImports(in: implementation.expressions.retrieve, errors: &errors)
            case "Swift":
              swiftRetrieve = constructed
              disallowImports(in: implementation.expressions.retrieve, errors: &errors)
            default:
              errors.append(ConstructionError.unknownLanguage(implementation.language))
            }
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
        c: cStore,
        cSharp: cSharpStore,
        javaScript: javaScriptStore,
        kotlin: kotlinStore,
        swift: swiftStore
      )
      : ActionIntermediate.enumerationCase(
        names: names,
        enumerationType: type,
        access: access,
        testOnlyAccess: testOnlyAccess
      )
    let wrapAction: ActionIntermediate? = contents.map({ valueType in
      ActionIntermediate.enumerationWrap(
        enumerationType: type,
        caseIdentifier: names.identifier(),
        valueType: valueType,
        access: access,
        testOnlyAccess: testOnlyAccess,
        c: cStore,
        cSharp: cSharpStore,
        javaScript: javaScriptStore,
        kotlin: kotlinStore,
        swift: swiftStore
      )
    })
    let unwrapAction: ActionIntermediate? = contents.map({ valueType in
      ActionIntermediate.enumerationUnwrap(
        enumerationType: type,
        caseIdentifier: names.identifier(),
        valueType: valueType,
        access: access,
        testOnlyAccess: testOnlyAccess,
        c: cRetrieve,
        cSharp: cSharpRetrieve,
        javaScript: javaScriptRetrieve,
        kotlin: kotlinRetrieve,
        swift: swiftRetrieve
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
        cStore: cStore,
        cSharpStore: cSharpStore,
        javaScriptStore: javaScriptStore,
        kotlinStore: kotlinStore,
        swiftStore: swiftStore,
        cRetrieve: cRetrieve,
        cSharpRetrieve: cSharpRetrieve,
        javaScriptRetrieve: javaScriptRetrieve,
        kotlinRetrieve: kotlinRetrieve,
        swiftRetrieve: swiftRetrieve,
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
      cStore: cStore,
      cSharpStore: cSharpStore,
      javaScriptStore: javaScriptStore,
      kotlinStore: kotlinStore,
      swiftStore: swiftStore,
      cRetrieve: cRetrieve,
      cSharpRetrieve: cSharpRetrieve,
      javaScriptRetrieve: javaScriptRetrieve,
      kotlinRetrieve: kotlinRetrieve,
      swiftRetrieve: swiftRetrieve,
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
      cStore: cStore?.specializing(typeLookup: typeLookup),
      cSharpStore: cSharpStore?.specializing(typeLookup: typeLookup),
      javaScriptStore: javaScriptStore?.specializing(typeLookup: typeLookup),
      kotlinStore: kotlinStore?.specializing(typeLookup: typeLookup),
      swiftStore: swiftStore?.specializing(typeLookup: typeLookup),
      cRetrieve: cRetrieve?.specializing(typeLookup: typeLookup),
      cSharpRetrieve: cSharpRetrieve?.specializing(typeLookup: typeLookup),
      javaScriptRetrieve: javaScriptRetrieve?.specializing(typeLookup: typeLookup),
      kotlinRetrieve: kotlinRetrieve?.specializing(typeLookup: typeLookup),
      swiftRetrieve: swiftRetrieve?.specializing(typeLookup: typeLookup),
      documentation: documentation?.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      declaration: declaration
    )
  }
}
