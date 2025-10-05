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
  var deservesTesting: Bool

  var isFlow: Bool {
    return prototype.isFlow
  }
  var documentation: DocumentationIntermediate? {
    get {
      return prototype.documentation
    }
    set {
      prototype.documentation = newValue
    }
  }
  var names: Set<UnicodeText> {
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
  var nativeNames: NativeActionNamesIntermediate {
    return prototype.nativeNames
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
    names: Set<UnicodeText>,
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
        access: .anywhereCapableOfDiscovery,
        testOnlyAccess: false,
        documentation: nil,
        nativeNames: .none
      ),
      isCreation: false,
      isSpecialized: false,
      deservesTesting: false
    )
  }

  static func partReference(
    names: Set<UnicodeText>,
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
        nativeNames: .none
      ),
      isCreation: false,
      isMemberWrapper: true,
      isSpecialized: false,
      deservesTesting: false
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
        nativeNames: .none
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["(", ").", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("container"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("part"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      isCreation: false,
      isSpecialized: false,
      deservesTesting: false
    )
  }

  static func enumerationCase(
    names: Set<UnicodeText>,
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
        nativeNames: .none
      ),
      isCreation: false,
      isMemberWrapper: true,
      isSpecialized: false,
      deservesTesting: false
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
        nativeNames: .none
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["(", ") {", ", {", "}}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!, typeInstead: enumerationType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!)
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["new ", "(", ")"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!)
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["Object.freeze({ enumerationCase: ", ", value: ", " })"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!)
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", "(", ")"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!)
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", "(", ")"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!)
          ]
        )
      ),
      isCreation: false,
      isEnumerationValueWrapper: true,
      isSpecialized: false,
      deservesTesting: false
    )
  }

  static func enumerationWrapNothing(
    names: Set<UnicodeText>,
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
        nativeNames: .none
      ),
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift,
      isCreation: false,
      isMemberWrapper: true,
      isSpecialized: false,
      deservesTesting: false
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
        nativeNames: .none
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", " enumeration = ", "; if (enumeration.enumeration_case == ", ") { ", " ", " = enumeration.value.", ";", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!, typeInstead: enumerationType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!, typeInstead: valueType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["if (", " is ", " enumerationCase", ") { ", " ", " = enumerationCase", ".Value;", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("+"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!, typeInstead: valueType),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("+"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["let enumeration = ", "; if (enumeration.enumerationCase == ", ") { let ", " = enumeration.value;", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["if (", " is ", ") { val ", " = ", ".value", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["if case ", "(let ", ") = ", " {", "}"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("value"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("consequence"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      isCreation: false,
      isSpecialized: false,
      deservesTesting: false
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
        returnValue: .simple(SimpleTypeReference(ParsedUninterruptedIdentifier(source: UnicodeText("truth value"), origin: compilerGeneratedOrigin())!)),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        nativeNames: .none
      ),
      c: c ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".enumeration_case == ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!, caseInstead: caseInstead),
          ]
        )
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", " is ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!, caseInstead: caseInstead),
          ]
        )
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", ".enumerationCase == ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!, caseInstead: caseInstead),
          ]
        )
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["", " is ", ""].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!, caseInstead: caseInstead),
          ]
        )
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        expression: NativeActionExpressionIntermediate(
          textComponents: ["{ if case ", " = ", " { return true } else { return false } }()"].map({ UnicodeText($0) }),
          parameters: [
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("case"), origin: compilerGeneratedOrigin())!, caseInstead: caseInstead),
            NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: UnicodeText("enumeration"), origin: compilerGeneratedOrigin())!),
          ]
        )
      ),
      isCreation: false,
      isSpecialized: false,
      deservesTesting: false
    )
  }

  static func construct<Declaration>(
    _ declaration: Declaration,
    namespace: [Set<UnicodeText>]
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
          switch implementation.language.identifierText() {
          case "C":
            c = constructed
          case "C♯":
            cSharp = constructed
          case "JavaScript":
            javaScript = constructed
            disallowImports(in: implementation, errors: &errors)
          case "Kotlin":
            kotlin = constructed
          case "Swift":
            swift = constructed
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
        switch StatementListIntermediate.construct(source) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenLiteral($0) }))
        case .success(let constructed):
          implementation = constructed
        }
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
        isSpecialized: false,
        deservesTesting: !isCreation
      )
    )
  }

  func validateReferences(referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    prototype.validateReferences(
      referenceLookup: referenceLookup,
      errors: &errors
    )
    let testContext = TestContext.inherited(visibility: access, isTestOnly: testOnlyAccess)
    for native in allNativeImplementations() {
      for parameterReference in native.expression.parameters {
        if let typeInstead = parameterReference.typeInstead {
          typeInstead.validateReferences(
            requiredAccess: access,
            testContext: testContext,
            referenceLookup: referenceLookup,
            errors: &errors
          )
        } else {
          if prototype.parameters.parameter(named: parameterReference.name) == nil,
            parameterReference.name != "‐",
            parameterReference.name != "+",
            parameterReference.name != "−" {
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
            testContext: testContext,
            referenceLookup: referenceLookup,
            errors: &errors
          )
        } else {
          if parameters.parameter(named: parameterReference.name) == nil {
            if parameterReference.name != "‐" {
              errors.append(.noSuchParameter(parameterReference.syntaxNode))
            }
          }
        }
      }
    }
    let externalAndParameters = referenceLookup.appending(self.parameterReferenceDictionary(externalLookup: referenceLookup))
    implementation?.validateReferences(
      context: externalAndParameters,
      testContext: nil,
      errors: &errors
    )
    documentation?.validateReferences(
      inheritedVisibility: access,
      referenceLookup: externalAndParameters,
      errors: &errors
    )
  }
}

extension ActionIntermediate {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
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
        nativeNames: nativeNames
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
      isSpecialized: isSpecialized,
      deservesTesting: deservesTesting
    )
  }

  func merging(
    requirement: RequirementIntermediate,
    useAccess: AccessIntermediate,
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>]
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
      specializationNamespace: specializationNamespace,
      specializationVisibility: access
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
          nativeNames: nativeNames.merging(requirement: requirement.nativeNames)
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
        isSpecialized: isSpecialized,
        deservesTesting: deservesTesting
      )
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>]
  ) -> ActionIntermediate {
    let newParameters = parameters.mappingParameters({ parameter in
      return parameter.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    let newReturnValue = returnValue.flatMap { $0.specializing(typeLookup: typeLookup) }
    let newAccess = min(self.access, use.access)
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace,
        specializationVisibility: newAccess
      )
    })
    var nativeImplementationTypeLookup = typeLookup
    for parameter in newParameters.inAnyOrder {
      for name in parameter.names {
        nativeImplementationTypeLookup[name] = nil
      }
    }
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: isFlow,
        names: names,
        namespace: prototype.namespace,
        parameters: newParameters,
        returnValue: newReturnValue,
        access: newAccess,
        testOnlyAccess: self.testOnlyAccess || use.testOnlyAccess,
        documentation: newDocumentation,
        nativeNames: nativeNames
      ),
      c: c?.specializing(implementationTypeLookup: nativeImplementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      cSharp: cSharp?.specializing(implementationTypeLookup: nativeImplementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      javaScript: javaScript?.specializing(implementationTypeLookup: nativeImplementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      kotlin: kotlin?.specializing(implementationTypeLookup: nativeImplementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      swift: swift?.specializing(implementationTypeLookup: nativeImplementationTypeLookup, requiredDeclarationTypeLookup: typeLookup),
      implementation: implementation?.specializing(typeLookup: typeLookup),
      declaration: declaration,
      isCreation: isCreation,
      isReferenceWrapper: isReferenceWrapper,
      isMemberWrapper: isMemberWrapper,
      isEnumerationValueWrapper: isEnumerationValueWrapper,
      originalUnresolvedCoverageRegionIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      coveredIdentifier: coveredIdentifier,
      isSpecialized: true,
      deservesTesting: deservesTesting
    )
  }

  mutating func resolveSpecializedAccess(to new: AccessIntermediate) {
    self.access = new
    if let tests = documentation?.tests {
      for index in tests.indices {
        documentation?.tests[index].inheritedVisibility = new
      }
    }
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
        nativeNames: .none
      ),
      isCreation: false,
      isReferenceWrapper: true,
      isSpecialized: isSpecialized,
      deservesTesting: false
    )
  }
}

extension ActionIntermediate {

  var isCoverageWrapper: Bool {
    return coveredIdentifier != nil
  }

  func coverageTrackingIdentifier() -> UnicodeText {
    return UnicodeText("☐\(prototype.names.identifier())")
  }
  func wrappedToTrackCoverage(referenceLookup: [ReferenceDictionary]) -> ActionIntermediate? {
    if let coverageIdentifier = coverageRegionIdentifier(referenceLookup: referenceLookup) {
      let baseName = names.identifier()
      let wrapperName = coverageTrackingIdentifier()
      return ActionIntermediate(
        prototype: ActionPrototype(
          isFlow: isFlow,
          names: [wrapperName],
          namespace: [],
          parameters: prototype.parameters
            .removingOtherNamesAnd(replacing: baseName, with: wrapperName)
            .prefixingEach(with: UnicodeText("→")),
          returnValue: prototype.returnValue,
          access: prototype.access,
          testOnlyAccess: prototype.testOnlyAccess,
          documentation: nil,
          nativeNames: .none
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
        isSpecialized: isSpecialized,
        deservesTesting: false
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
          result.append(UnicodeText("\(base):{\(entry.inDigits())}"))
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
  func identifier<P>(for platform: P.Type, referenceLookup: [ReferenceDictionary]) -> UnicodeText?
  where P: Platform {
    guard let nameDeclaration = platform.nativeNameDeclaration(of: self) else {
      return nil
    }
    var name = StrictString(nameDeclaration)
    if let overridePrefix = platform.overridePrefix,
      name.hasPrefix(StrictString(overridePrefix)) {
      name.removeFirst(overridePrefix.count)
    }
    var isVariable = false
    if let variablePrefix = platform.variablePrefix,
      name.hasPrefix(StrictString(variablePrefix)) {
        name.removeFirst(variablePrefix.count)
        isVariable = true
    }
    if let memberPrefix = platform.memberPrefix,
      name.hasPrefix(StrictString(memberPrefix)) {
      name.removeFirst(memberPrefix.count)
    }
    var disambiguatorParameters: [Int] = []
    if !platform.permitsOverloads {
      while let typePrefix = name.prefix(upTo: " "),
        typePrefix.contents.allSatisfy({ $0.isASCII && $0.properties.numericType == .decimal }),
        let parsedNumber = Int(String(StrictString(typePrefix.contents))) {
          disambiguatorParameters.append(parsedNumber)
          name.removeFirst(typePrefix.contents.count)
          name.removeFirst()
      }
    }
    let firstSpace = name.firstIndex(of: " ")
    var functionName = StrictString(name[..<(firstSpace ?? name.endIndex)])
    if let space = firstSpace {
      name.removeSubrange(...space)
    } else {
      name.removeSubrange(..<name.endIndex)
    }
    if platform.usesSnakeCase {
      functionName.replaceMatches(for: "‐", with: "_")
    }
    for parameterIndex in disambiguatorParameters.reversed() {
      let zeroBased = parameterIndex - 1
      let parameters = self.parameters.ordered(for: nameDeclaration)
      let parameterType: ParsedTypeReference
      if zeroBased == parameters.endIndex {
        parameterType = returnValue!
      } else {
        parameterType = parameters[zeroBased].type
      }
      let type = platform.source(for: parameterType, referenceLookup: referenceLookup)
      functionName.prepend(contentsOf: "\(P.identifierPrefix(for: type))_".scalars)
    }
    if let initializerSuffix = platform.initializerSuffix,
      functionName.hasSuffix(StrictString(initializerSuffix)) {
      functionName = StrictString(platform.initializerName)
    }
    var parameterNames: [UnicodeText] = []
    while !name.isEmpty {
      if name.hasPrefix("()".scalars.literal()) {
        parameterNames.append(platform.emptyParameterLabel)
        name.removeFirst(2)
      } else {
        guard let next = name.firstIndex(of: "(") else {
          fatalError("Illegal postfix name component: \(platform.nativeNameDeclaration(of: self)!)")
        }
        guard platform.permitsParameterLabels else {
          fatalError("Illegal parameter label: \(platform.nativeNameDeclaration(of: self)!)")
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
    let parameters = parameterNames.map({ "\($0)\(platform.parameterLabelSuffix)" }).joined()
    let parameterSection = isVariable ? "" : "(\(parameters))"
    return UnicodeText("\(functionName)\(parameterSection)")
  }
  func swiftSignature(referenceLookup: [ReferenceDictionary]) -> UnicodeText? {
    guard let name = nativeNames.swift,
      let identifier = identifier(for: Swift.self, referenceLookup: referenceLookup).map({ StrictString($0) }) else {
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
            platform.source(for: indirectRequirement, referenceLookup: moduleAndExternalReferenceLookup)
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
