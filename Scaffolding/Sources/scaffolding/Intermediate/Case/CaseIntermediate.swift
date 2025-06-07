struct CaseIntermediate {
  var names: Set<UnicodeText>
  var contents: ParsedTypeReference?
  var referenceAction: ActionIntermediate?
  var wrapAction: ActionIntermediate
  var unwrapAction: ActionIntermediate?
  var checkAction: ActionIntermediate
  var documentation: DocumentationIntermediate?
  var declaration: ParsedCaseDeclaration
}

extension CaseIntermediate {

  static func disallowImports(
    in implementation: ParsedNativeAction,
    errors: inout [ConstructionError]
  ) {
    if implementation.importNode != nil {
      errors.append(ConstructionError.invalidImport(implementation))
    }
  }

  static func construct(
    _ declaration: ParsedCaseDeclaration,
    namespace: [Set<UnicodeText>],
    type: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> Result<CaseIntermediate, ErrorList<CaseIntermediate.ConstructionError>> {
    var errors: [CaseIntermediate.ConstructionError] = []

    var names: Set<UnicodeText> = []
    for name in declaration.name.names.names {
      names.insert(name.name.identifierText())
    }

    let caseNamespace = namespace.appending(names)

    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      switch DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: caseNamespace
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
    var cCheck: NativeActionImplementationIntermediate?
    var cSharpCheck: NativeActionImplementationIntermediate?
    var javaScriptCheck: NativeActionImplementationIntermediate?
    var kotlinCheck: NativeActionImplementationIntermediate?
    var swiftCheck: NativeActionImplementationIntermediate?
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
            case "JavaScript":
              javaScriptStore = constructed
              disallowImports(in: implementation.expression, errors: &errors)
            case "Kotlin":
              kotlinStore = constructed
            case "Swift":
              swiftStore = constructed
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
            case "JavaScript":
              javaScriptStore = constructed
              disallowImports(in: implementation.expressions.store, errors: &errors)
            case "Kotlin":
              kotlinStore = constructed
            case "Swift":
              swiftStore = constructed
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
            case "JavaScript":
              javaScriptRetrieve = constructed
              disallowImports(in: implementation.expressions.retrieve, errors: &errors)
            case "Kotlin":
              kotlinRetrieve = constructed
            case "Swift":
              swiftRetrieve = constructed
            default:
              errors.append(ConstructionError.unknownLanguage(implementation.language))
            }
          }
          switch NativeActionImplementationIntermediate.construct(
            implementation: implementation.expressions.check
          ) {
          case .failure(let error):
            errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeCaseImplementation($0) }))
          case .success(let constructed):
            switch implementation.language.identifierText() {
            case "C":
              cCheck = constructed
            case "C♯":
              cSharpCheck = constructed
            case "JavaScript":
              javaScriptCheck = constructed
              disallowImports(in: implementation.expressions.check, errors: &errors)
            case "Kotlin":
              kotlinCheck = constructed
            case "Swift":
              swiftCheck = constructed
            default:
              errors.append(ConstructionError.unknownLanguage(implementation.language))
            }
          }
        }
      }
    }

    let contents = (declaration.contents?.type).map({ ParsedTypeReference($0) })

    let referenceAction: ActionIntermediate? = contents.map { _ in
      return ActionIntermediate.enumerationCase(
        names: names,
        enumerationType: type,
        access: access,
        testOnlyAccess: testOnlyAccess
      )
    }
    let wrapAction: ActionIntermediate = contents.map({ valueType in
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
    }) ?? ActionIntermediate.enumerationWrapNothing(
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
    let checkAction = ActionIntermediate.enumerationCheck(
      enumerationType: type,
      caseIdentifier: names.identifier(),
      empty: contents == nil,
      access: access,
      testOnlyAccess: testOnlyAccess,
      c: cCheck,
      cSharp: cSharpCheck,
      javaScript: javaScriptCheck,
      kotlin: kotlinCheck,
      swift: swiftCheck
    )

    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      CaseIntermediate(
        names: names,
        contents: contents,
        referenceAction: referenceAction,
        wrapAction: wrapAction,
        unwrapAction: unwrapAction,
        checkAction: checkAction,
        documentation: attachedDocumentation,
        declaration: declaration
      )
    )
  }
}

extension CaseIntermediate {

  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> CaseIntermediate {
    return CaseIntermediate(
      names: names,
      contents: contents?.resolvingExtensionContext(typeLookup: typeLookup),
      referenceAction: referenceAction?.resolvingExtensionContext(typeLookup: typeLookup),
      wrapAction: wrapAction.resolvingExtensionContext(typeLookup: typeLookup),
      unwrapAction: unwrapAction?.resolvingExtensionContext(typeLookup: typeLookup),
      checkAction: checkAction.resolvingExtensionContext(typeLookup: typeLookup),
      documentation: documentation?.resolvingExtensionContext(typeLookup: typeLookup),
      declaration: declaration
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>]
  ) -> CaseIntermediate {
    return CaseIntermediate(
      names: names,
      contents: contents?.specializing(typeLookup: typeLookup),
      referenceAction: referenceAction?.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      wrapAction: wrapAction.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      unwrapAction: unwrapAction?.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      checkAction: checkAction.specializing(
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
