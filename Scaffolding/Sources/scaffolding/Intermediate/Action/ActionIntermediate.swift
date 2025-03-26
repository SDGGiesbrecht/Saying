import SDGText

struct ActionIntermediate {
  fileprivate var prototype: ActionPrototype
  var c: NativeActionImplementationIntermediate?
  var cSharp: NativeActionImplementationIntermediate?
  var javaScript: NativeActionImplementationIntermediate?
  var kotlin: NativeActionImplementationIntermediate?
  var swift: NativeActionImplementationIntermediate?
  var implementation: StatementListIntermediate?
  var declaration: ParsedActionDeclarationPrototype?
  var isCreation: Bool
  var isReferenceWrapper: Bool = false
  var isMemberWrapper: Bool = false
  var isEnumerationValueWrapper: Bool = false
  var originalUnresolvedCoverageRegionIdentifierComponents: [UnicodeText]?
  var coveredIdentifier: UnicodeText?
  var isSpecialized: Bool

  var isFlow: Bool {
    return prototype.isFlow
  }
  var documentation: DocumentationIntermediate? {
    return prototype.documentation
  }
  var names: Set<StrictString> {
    return prototype.names
  }
  var parameters: Interpolation<ParameterIntermediate> {
    return prototype.parameters
  }
  var returnValue: ParsedTypeReference? {
    return prototype.returnValue
  }
  var access: AccessIntermediate {
    get {
      return prototype.access
    }
    set {
      prototype.access = newValue
    }
  }
  var testOnlyAccess: Bool {
    get {
      return prototype.testOnlyAccess
    }
    set {
      prototype.testOnlyAccess = newValue
    }
  }
  var swiftName: UnicodeText? {
    return prototype.swiftName
  }
  func allNativeImplementations() -> [NativeActionImplementationIntermediate] {
    return [c, cSharp, javaScript, kotlin, swift].compactMap({ $0 })
  }
}

extension ActionIntermediate {
  func parameterReferenceDictionary(externalLookup: [ReferenceDictionary]) -> ReferenceDictionary {
    return prototype.parameterReferenceDictionary(externalLookup: externalLookup)
  }
}

extension ActionIntermediate {
  func unresolvedGloballyUniqueIdentifierComponents() -> [UnicodeText] {
    let identifier = names.identifier()
    let signature = signature(orderedFor: identifier)
    let resolvedParameters: [ParsedTypeReference]
    let resolvedReturnValue: ParsedTypeReference?
    if isReferenceWrapper {
      switch returnValue {
      case .simple, .compound, .statements, .partReference, .enumerationCase, .none:
        fatalError("A real action reference would produce an action.")
      case .action(parameters: let parameters, returnValue: let returnValue):
        resolvedParameters = parameters
        resolvedReturnValue = returnValue
      }
    } else {
      resolvedParameters = signature
      resolvedReturnValue = self.returnValue
    }
    return [identifier]
      .appending(contentsOf: resolvedParameters.lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      .appending(contentsOf: resolvedReturnValue.unresolvedGloballyUniqueIdentifierComponents())
  }

  func resolve(
    globallyUniqueIdentifierComponents: [UnicodeText],
    referenceLookup: [ReferenceDictionary]
  ) -> UnicodeText {
    return UnicodeText(
      globallyUniqueIdentifierComponents
        .lazy.map({ StrictString(referenceLookup.resolve(identifier: $0)) })
        .joined(separator: ":")
    )
  }

  func globallyUniqueIdentifier(referenceLookup: [ReferenceDictionary]) -> UnicodeText {
    return resolve(
      globallyUniqueIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      referenceLookup: referenceLookup
    )
  }
}

extension ActionIntermediate {

  static func disallowImports(
    in implementation: ParsedNativeActionImplementation,
    errors: inout [ConstructionError]
  ) {
    if implementation.expression.importNode != nil {
      errors.append(ConstructionError.invalidImport(implementation))
    }
  }

  static func parameterAction(
    names: Set<StrictString>,
    parameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference?
  ) -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: false,
        names: names,
        namespace: [],
        parameters: parameters,
        returnValue: returnValue,
        access: .inferred,
        testOnlyAccess: false,
        documentation: nil,
        swiftName: nil
      ),
      isCreation: false,
      isSpecialized: false
    )
  }

  static func partReference(
    names: Set<StrictString>,
    containerType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: names,
        namespace: [],
        parameters: .none,
        returnValue: .partReference(container: containerType, identifier: names.identifier()),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      isCreation: false,
      isMemberWrapper: true,
      isSpecialized: false
    )
  }

  static func accessor(
    containerType: ParsedTypeReference,
    partIdentifier: UnicodeText,
    partType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    let parameters = Interpolation<ParameterIntermediate>.accessor(
      containerType: containerType,
      partIdentifier: partIdentifier
    )
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: parameters.names(),
        namespace: [],
        parameters: parameters,
        returnValue: partType,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["(", ").", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"))!),
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"))!),
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"))!),
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"))!),
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"))!),
          ]
        )
      ),
      isCreation: false,
      isSpecialized: false
    )
  }

  static func enumerationCase(
    names: Set<StrictString>,
    enumerationType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: names,
        namespace: [],
        parameters: .none,
        returnValue: .enumerationCase(enumeration: enumerationType, identifier: names.identifier()),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      isCreation: false,
      isMemberWrapper: true,
      isSpecialized: false
    )
  }

  static func enumerationWrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: UnicodeText,
    valueType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    let parameters = Interpolation<ParameterIntermediate>.enumerationWrap(
      enumerationType: enumerationType,
      caseIdentifier: caseIdentifier,
      valueType: valueType
    )
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: parameters.names(),
        namespace: [],
        parameters: parameters,
        returnValue: enumerationType,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["(", ") {", ", {", "}}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!, typeInstead: enumerationType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!)
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["new ", "(", ")"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!)
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["Object.freeze({ enumerationCase: ", ", value: ", " })"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!)
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", "(", ")"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!)
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", "(", ")"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!)
          ]
        )
      ),
      isCreation: false,
      isEnumerationValueWrapper: true,
      isSpecialized: false
    )
  }

  static func enumerationWrapNothing(
    names: Set<StrictString>,
    returnValue: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: false,
        names: names,
        namespace: [],
        parameters: .none,
        returnValue: returnValue,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift,
      isCreation: false,
      isMemberWrapper: true,
      isSpecialized: false
    )
  }

  static func enumerationUnwrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: UnicodeText,
    valueType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    let parameters = Interpolation<ParameterIntermediate>.enumerationUnwrap(
      enumerationType: enumerationType,
      caseIdentifier: caseIdentifier,
      valueType: valueType
    )
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: parameters.names(),
        namespace: [],
        parameters: parameters,
        returnValue: nil,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", " enumeration = ", "; if (enumeration.enumeration_case == ", ") { ", " ", " = enumeration.value.", ";", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!, typeInstead: enumerationType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!, typeInstead: valueType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"))!),
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["if (", " is ", " enumerationCase", ") { ", " ", " = enumerationCase", ".Value;", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("+"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!, typeInstead: valueType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("+"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"))!),
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["let enumeration = ", "; if (enumeration.enumerationCase == ", ") { let ", " = enumeration.value;", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"))!),
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["if (", " is ", ") { val ", " = ", ".value", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"))!),
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["if case ", "(let ", ") = ", " {", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"))!),
          ]
        )
      ),
      isCreation: false,
      isSpecialized: false
    )
  }

  static func enumerationCheck(
    enumerationType: ParsedTypeReference,
    caseIdentifier: UnicodeText,
    empty: Bool,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    let parameters = Interpolation<ParameterIntermediate>.enumerationCheck(
      enumerationType: enumerationType,
      caseIdentifier: caseIdentifier,
      empty: empty
    )
    let caseInstead: ParsedTypeReference? = empty ? .enumerationCase(enumeration: enumerationType, identifier: caseIdentifier) : nil
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: parameters.names(),
        namespace: [],
        parameters: parameters,
        returnValue: .simple(SimpleTypeReference(ParsedUninterruptedIdentifier(source: UnicodeText("truth value"))!)),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".enumeration_case == ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!, caseInstead: caseInstead),
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", " is ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!, caseInstead: caseInstead),
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".enumerationCase == ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!, caseInstead: caseInstead),
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", " is ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!, caseInstead: caseInstead),
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["{ if case ", " = ", " { return true } else { return false } }()"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"))!, caseInstead: caseInstead),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"))!),
          ]
        )
      ),
      isCreation: false,
      isSpecialized: false
    )
  }

  static func construct<Declaration>(
    _ declaration: Declaration,
    namespace: [Set<StrictString>]
  ) -> Result<ActionIntermediate, ErrorList<ActionIntermediate.ConstructionError>>
  where Declaration: ParsedActionDeclarationPrototype {
    var errors: [ActionIntermediate.ConstructionError] = []

    let prototype: ActionPrototype
    switch ActionPrototype.construct(declaration, namespace: namespace) {
    case .failure(let prototypeError):
      errors.append(contentsOf: prototypeError.errors.map({ .brokenPrototype($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      prototype = constructed
    }
    var c: NativeActionImplementationIntermediate?
    var cSharp: NativeActionImplementationIntermediate?
    var javaScript: NativeActionImplementationIntermediate?
    var kotlin: NativeActionImplementationIntermediate?
    var swift: NativeActionImplementationIntermediate?
    if let native = declaration.implementation.native {
      for implementation in native.implementations {
        switch NativeActionImplementationIntermediate.construct(
          implementation: implementation.expression
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeActionImplementation($0) }))
        case .success(let constructed):
          switch StrictString(implementation.language.identifierText()) {
          case "C":
            c = constructed
          case "C♯":
            cSharp = constructed
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
    var isCreation = false
    var implementation: StatementListIntermediate?
    if let source = declaration.implementation.source {
      switch source {
      case .source(let source):
        implementation = StatementListIntermediate(source)
      case .creation:
        isCreation = true
        break
      }
    } else {
      if c == nil {
        errors.append(ConstructionError.missingImplementation(language: UnicodeText("C"), action: declaration.name))
      }
      if cSharp == nil {
        errors.append(ConstructionError.missingImplementation(language: UnicodeText("C♯"), action: declaration.name))
      }
      if javaScript == nil {
        errors.append(ConstructionError.missingImplementation(language: UnicodeText("JavaScript"), action: declaration.name))
      }
      if kotlin == nil {
        errors.append(ConstructionError.missingImplementation(language: UnicodeText("Kotlin"), action: declaration.name))
      }
      if swift == nil {
        errors.append(ConstructionError.missingImplementation(language: UnicodeText("Swift"), action: declaration.name))
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionIntermediate(
        prototype: prototype,
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift,
        implementation: implementation,
        declaration: declaration,
        isCreation: isCreation,
        isSpecialized: false
      )
    )
  }

  func validateReferences(referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    prototype.validateReferences(
      referenceLookup: referenceLookup,
      errors: &errors
    )
    for native in allNativeImplementations() {
      for parameterReference in native.expression.parameters {
        if let typeInstead = parameterReference.typeInstead {
          typeInstead.validateReferences(
            requiredAccess: access,
            allowTestOnlyAccess: testOnlyAccess,
            referenceLookup: referenceLookup,
            errors: &errors
          )
        } else {
          if prototype.parameters.parameter(named: parameterReference.name) == nil,
            StrictString(parameterReference.name) != "+",
            StrictString(parameterReference.name) != "−" {
            errors.append(.noSuchParameter(parameterReference.syntaxNode))
          }
        }
      }
      for parameterReference in native.indirectRequirements.compactMap({ $0.parameters })
        .appending(contentsOf: native.requiredDeclarations.compactMap({ $0.parameters }))
        .joined() {
        if let typeInstead = parameterReference.resolvedType {
          typeInstead.validateReferences(
            requiredAccess: access,
            allowTestOnlyAccess: testOnlyAccess,
            referenceLookup: referenceLookup,
            errors: &errors
          )
        } else {
          if parameters.parameter(named: parameterReference.name) == nil {
            errors.append(.noSuchParameter(parameterReference.syntaxNode))
          }
        }
      }
    }
    let externalAndParameters = referenceLookup.appending(self.parameterReferenceDictionary(externalLookup: referenceLookup))
    implementation?.validateReferences(
      context: externalAndParameters,
      testContext: false,
      errors: &errors
    )
    documentation?.validateReferences(
      referenceLookup: externalAndParameters,
      errors: &errors
    )
  }
}

extension ActionIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: UnicodeText]
  ) -> ActionIntermediate {
    let newParameters = parameters.mappingParameters({ parameter in
      return parameter.resolvingExtensionContext(typeLookup: typeLookup)
    })
    let newReturnValue = returnValue.flatMap { $0.resolvingExtensionContext(typeLookup: typeLookup) }
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.resolvingExtensionContext(typeLookup: typeLookup)
    })
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: isFlow,
        names: names,
        namespace: prototype.namespace,
        parameters: newParameters,
        returnValue: newReturnValue,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: newDocumentation,
        swiftName: swiftName
      ),
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift,
      implementation: implementation,
      declaration: declaration,
      isCreation: isCreation,
      isReferenceWrapper: isReferenceWrapper,
      isMemberWrapper: isMemberWrapper,
      isEnumerationValueWrapper: isEnumerationValueWrapper,
      originalUnresolvedCoverageRegionIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      coveredIdentifier: coveredIdentifier,
      isSpecialized: isSpecialized
    )
  }

  func merging(
    requirement: RequirementIntermediate,
    useAccess: AccessIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> Result<ActionIntermediate, ErrorList<ReferenceError>> {
    var errors: [ReferenceError] = []
    let mergedParameters: Interpolation<ParameterIntermediate>
    switch parameters.merging(
      requirement: requirement.parameters,
      provisionDeclarationName: self.declaration!.name
    ) {
    case .failure(let error):
      errors.append(contentsOf: error.errors)
      return .failure(ErrorList(errors))
    case .success(let parameters):
      mergedParameters = parameters
    }
    if access < min(requirement.access, useAccess) {
      errors.append(.fulfillmentAccessNarrowerThanRequirement(declaration: self.declaration!.name))
    }
    if testOnlyAccess != requirement.testOnlyAccess {
      errors.append(.mismatchedTestAccess(testAccess: self.declaration!.testAccess!))
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    let mergedDocumentation = documentation.merging(
      inherited: requirement.documentation,
      typeLookup: typeLookup,
      specializationNamespace: specializationNamespace
    )
    return .success(
      ActionIntermediate(
        prototype: ActionPrototype(
          isFlow: isFlow,
          names: names.union(requirement.names),
          namespace: prototype.namespace,
          parameters: mergedParameters,
          returnValue: returnValue,
          access: access,
          testOnlyAccess: testOnlyAccess,
          documentation: mergedDocumentation,
          swiftName: swiftName ?? requirement.swiftName
        ),
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift,
        implementation: implementation,
        declaration: declaration,
        isCreation: isCreation,
        isReferenceWrapper: isReferenceWrapper,
        isMemberWrapper: isMemberWrapper,
        isEnumerationValueWrapper: isEnumerationValueWrapper,
        originalUnresolvedCoverageRegionIdentifierComponents: nil,
        coveredIdentifier: coveredIdentifier,
        isSpecialized: isSpecialized
      )
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> ActionIntermediate {
    let newParameters = parameters.mappingParameters({ parameter in
      return parameter.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    let newReturnValue = returnValue.flatMap { $0.specializing(typeLookup: typeLookup) }
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    var implementationTypeLookup = typeLookup
    for parameter in newParameters.inAnyOrder {
      for name in parameter.names {
        implementationTypeLookup[name] = nil
      }
    }
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: isFlow,
        names: names,
        namespace: prototype.namespace,
        parameters: newParameters,
        returnValue: newReturnValue,
        access: min(self.access, use.access),
        testOnlyAccess: self.testOnlyAccess || use.testOnlyAccess,
        documentation: newDocumentation,
        swiftName: swiftName
      ),
      c: c?.specializing(implementationTypeLookup: implementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      cSharp: cSharp?.specializing(implementationTypeLookup: implementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      javaScript: javaScript?.specializing(implementationTypeLookup: implementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      kotlin: kotlin?.specializing(implementationTypeLookup: implementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      swift: swift?.specializing(implementationTypeLookup: implementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      implementation: implementation?.specializing(typeLookup: implementationTypeLookup),
      declaration: declaration,
      isCreation: isCreation,
      isReferenceWrapper: isReferenceWrapper,
      isMemberWrapper: isMemberWrapper,
      isEnumerationValueWrapper: isEnumerationValueWrapper,
      originalUnresolvedCoverageRegionIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      coveredIdentifier: coveredIdentifier,
      isSpecialized: true
    )
  }
}

extension ActionIntermediate {
  func lookupParameter(_ identifier: UnicodeText) -> ParameterIntermediate? {
    return prototype.lookupParameter(identifier)
  }

  func signature(orderedFor name: UnicodeText) -> [ParsedTypeReference] {
    return prototype.signature(orderedFor: name)
  }
}

extension ActionIntermediate {
  func asReference() -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: false,
        names: names,
        namespace: [],
        parameters: .none,
        returnValue: .action(
          parameters: parameters.ordered(for: names.identifier()).map({ $0.type }),
          returnValue: returnValue),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      isCreation: false,
      isReferenceWrapper: true,
      isSpecialized: isSpecialized
    )
  }
}

extension ActionIntermediate {

  var isCoverageWrapper: Bool {
    return coveredIdentifier != nil
  }

  func coverageTrackingIdentifier() -> UnicodeText {
    return UnicodeText("☐\(StrictString(prototype.names.identifier()))")
  }
  func wrappedToTrackCoverage(referenceLookup: [ReferenceDictionary]) -> ActionIntermediate? {
    if let coverageIdentifier = coverageRegionIdentifier(referenceLookup: referenceLookup) {
      let baseName = names.identifier()
      let wrapperName = coverageTrackingIdentifier()
      return ActionIntermediate(
        prototype: ActionPrototype(
          isFlow: isFlow,
          names: [StrictString(wrapperName)],
          namespace: [],
          parameters: prototype.parameters
            .removingOtherNamesAnd(replacing: baseName, with: wrapperName)
            .prefixingEach(with: UnicodeText("→")),
          returnValue: prototype.returnValue,
          access: prototype.access,
          testOnlyAccess: prototype.testOnlyAccess,
          documentation: nil,
          swiftName: nil
        ),
        implementation: StatementListIntermediate(
          statements: [
            StatementIntermediate(
              isReturn: returnValue != nil,
              action: ActionUse(
                actionName: baseName,
                arguments: prototype.parameters
                  .prefixingEach(with: UnicodeText("→"))
                  .ordered(for: baseName).map({ parameter in
                  return .action(
                    ActionUse(
                      actionName: parameter.names.identifier(),
                      arguments: [],
                      passage: parameter.isThrough ? .through : .into,
                      resolvedResultType: parameter.type
                    )
                  )
                }),
                passage: .into,
                resolvedResultType: returnValue
              )
            )
          ]
        ),
        isCreation: false,
        originalUnresolvedCoverageRegionIdentifierComponents: nil,
        coveredIdentifier: coverageIdentifier,
        isSpecialized: isSpecialized
      )
    } else {
      return nil
    }
  }

  func coverageRegionIdentifier(referenceLookup: [ReferenceDictionary]) -> UnicodeText? {
    let namespace = prototype.namespace
      .lazy.map({ StrictString($0.identifier()) })
      .joined(separator: ":")
    let identifier: UnicodeText
    if let inherited = originalUnresolvedCoverageRegionIdentifierComponents {
      identifier = resolve(globallyUniqueIdentifierComponents: inherited, referenceLookup: referenceLookup)
    } else {
      identifier = globallyUniqueIdentifier(referenceLookup: referenceLookup)
    }
    return UnicodeText(
      [namespace, StrictString(identifier)]
        .joined(separator: ":")
    )
  }

  func allCoverageRegionIdentifiers(
    referenceLookup: [ReferenceDictionary],
    skippingSubregions: Bool
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
    if let base = coverageRegionIdentifier(referenceLookup: referenceLookup) {
      result.append(base)
      if !skippingSubregions {
        for entry in coverageSubregions() {
          result.append(UnicodeText("\(StrictString(base)):{\(entry.inDigits())}"))
        }
      }
    }
    return result
  }

  func coverageSubregions() -> [Int] {
    var counter: Int = 0
    return implementation?.coverageSubregions(counter: &counter) ?? []
  }
}

extension ActionIntermediate {
  func swiftIdentifier() -> UnicodeText? {
    guard var name = swiftName.map({ StrictString($0) }) else {
      return nil
    }
    var isVariable = false
    if name.hasPrefix("var ") {
      name.removeFirst(4)
      isVariable = true
    }
    if name.hasPrefix("().") {
      name.removeFirst(3)
    }
    let firstSpace = name.firstIndex(of: " ")
    var functionName = StrictString(name[..<(firstSpace ?? name.endIndex)])
    if let space = firstSpace {
      name.removeSubrange(...space)
    } else {
      name.removeSubrange(..<name.endIndex)
    }
    if functionName.hasSuffix(".init") {
      functionName = "init"
    }
    var parameterNames: [UnicodeText] = []
    while !name.isEmpty {
      if name.hasPrefix("()".scalars.literal()) {
        parameterNames.append(UnicodeText("_"))
        name.removeFirst(2)
      } else {
        guard let next = name.firstIndex(of: "(") else {
          fatalError("Swift cannot have postfix name components.")
        }
        var parameterName = StrictString(name[..<next])
        name.removeSubrange(..<next)
        if parameterName.last == " " {
          parameterName.removeLast()
        }
        parameterNames.append(UnicodeText(parameterName))
        if name.hasPrefix("()") {
          name.removeFirst(2)
        }
      }
      if name.hasPrefix(" ") {
        name.removeFirst()
      }
    }
    let parameters = parameterNames.map({ "\(StrictString($0)):" }).joined()
    let parameterSection = isVariable ? "" : "(\(parameters))"
    return UnicodeText("\(functionName)\(parameterSection)")
  }
  func swiftSignature(referenceLookup: [ReferenceDictionary]) -> UnicodeText? {
    guard let name = swiftName,
      let identifier = swiftIdentifier().map({ StrictString($0) }) else {
      return nil
    }
    let components = identifier.components(separatedBy: ":")
    var parameters = self.parameters.ordered(for: name)
    var result: StrictString = ""
    if components.count == parameters.count {
      let selfType = parameters.removeFirst()
      result.prepend(contentsOf: Swift.source(for: selfType.type, referenceLookup: referenceLookup).scalars)
      result.append(".")
    }
    for index in parameters.indices {
      if index != parameters.startIndex {
        result.append(contentsOf: ", ")
      }
      result.append(contentsOf: components[index].contents)
      result.append(contentsOf: ": ".scalars)
      result.append(contentsOf: Swift.source(for: parameters[index].type, referenceLookup: referenceLookup).scalars)
    }
    result.append(contentsOf: components.last!.contents)
    if result.hasPrefix("init(") {
      result.prepend(contentsOf: ".".scalars)
      result.prepend(contentsOf: Swift.source(for: returnValue!, referenceLookup: referenceLookup).scalars)
    }
    return UnicodeText(result)
  }
}

extension ActionIntermediate {

  func requiredIdentifiers<P>(
    moduleAndExternalReferenceLookup: [ReferenceDictionary],
    platform: P.Type
  ) -> [UnicodeText]
  where P: Platform {
    var result: [UnicodeText] = []
    result.append(
      contentsOf: prototype.requiredIdentifiers(
        moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
      )
    )
    if let native = platform.nativeImplementation(of: self) {
      for parameterReference in native.expression.parameters {
        if let typeInstead = parameterReference.typeInstead {
          result.append(
            contentsOf: typeInstead.requiredIdentifiers(
              moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
            )
          )
        }
      }
      for indirectRequirement in native.indirectRequirements {
        result.append(
          UnicodeText(
            StrictString(
              platform.source(for: indirectRequirement, referenceLookup: moduleAndExternalReferenceLookup)
            )
          )
        )
      }
    } else if let implementation = self.implementation {
      result.append(
        contentsOf: implementation.requiredIdentifiers(
          context: moduleAndExternalReferenceLookup
        )
      )
    }
    return result
  }
}
