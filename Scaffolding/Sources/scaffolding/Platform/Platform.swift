import Foundation

import SDGText

protocol Platform {
  // Miscellaneous
  static var directoryName: String { get }
  static var indent: String { get }

  // Identifiers
  static var allowsAllUnicodeIdentifiers: Bool { get }
  static var allowedIdentifierStartGeneralCategories: Set<Unicode.GeneralCategory> { get }
  static var allowedIdentifierStartCharacterPoints: [UInt32] { get }
  static var additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> { get }
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] { get }
  static var disallowedStringLiteralPoints: [UInt32] { get }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>? { get set }
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>? { get set }
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>? { get set }
  static var identifierLengthLimit: Int? { get }
  static func escapeForStringLiteral(character: Unicode.Scalar) -> String
  static func literal(scalars: String) -> String
  static func literal(scalar: Unicode.Scalar) -> String

  // Access
  static func accessModifier(for access: AccessIntermediate, memberScope: Bool) -> String?

  // Parts
  static func partDeclaration(
    name: String,
    type: String,
    accessModifier: String?,
    noSetter: Bool
  ) -> String

  // Cases
  static func caseReference(name: String, type: String, simple: Bool, ignoringValue: Bool) -> String
  static func caseDeclaration(
    name: String,
    contents: String?,
    index: Int,
    simple: Bool,
    parentType: String
  ) -> String
  static var needsSeparateCaseStorage: Bool { get }
  static func caseStorageDeclaration(
    name: String,
    contents: String,
    parentType: String
  ) -> String?

  // Things
  static var isTyped: Bool { get }
  static func nativeName(of thing: Thing) -> String?
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate?
  static func repair(compoundNativeType: String) -> String
  static func actionType(parameters: String, returnValue: String) -> String
  static func actionReferencePrefix(isVariable: Bool) -> String?
  static var infersConstructors: Bool { get }
  static func thingDeclaration(
    name: String,
    components: [String],
    accessModifier: String?,
    constructorParameters: [String],
    constructorAccessModifier: String?,
    constructorSetters: [String],
    otherMembers: [String]
  ) -> String?
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    accessModifier: String?,
    simple: Bool,
    storageCases: [String],
    otherMembers: [String]
  ) -> String

  // Actions
  static func nativeNameDeclaration(of action: ActionIntermediate) -> UnicodeText?
  static func nativeName(of parameter: ParameterIntermediate) -> String?
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String?
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate?
  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String
  static func createInstance(of type: String, parts: String) -> String
  static func constructorSetter(name: String) -> String
  static var needsReferencePreparation: Bool { get }
  static func prepareReference(to argument: String, update: Bool) -> String?
  static func passReference(to argument: String, forwarding: Bool, isAddressee: Bool) -> String
  static func unpackReference(to argument: String) -> String?
  static func dereference(throughParameter: String, forwarding: Bool) -> String
  static var emptyReturnType: String? { get }
  static var emptyReturnTypeForActionType: String { get }
  static func returnSection(with returnValue: String, isProperty: Bool) -> String?
  static var needsForwardDeclarations: Bool { get }
  static func forwardActionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?
  ) -> String?
  static func coverageRegistration(identifier: String) -> String
  static func statement(expression: String) -> String
  static func deadEnd() -> String
  static func returnDelayStorage(type: String?) -> String
  static var delayedReturn: String { get }
  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    accessModifier: String?,
    coverageRegistration: String?,
    implementation: [String],
    parentType: String?,
    isMutating: Bool,
    isAbsorbedMember: Bool,
    isOverride: Bool,
    propertyInstead: Bool,
    initializerInstead: Bool
  ) -> UniqueDeclaration

  // Imports
  static var fileSettings: String? { get }
  static func statementImporting(_ importTarget: String) -> String

  // Native Requirements
  static var preexistingNativeRequirements: Set<String> { get }
  static func isAlgorithmicallyPreexistingNativeRequirement(source: String) -> Bool

  // Module
  static var importsNeededByMemoryManagement: Set<String> { get }
  static var importsNeededByDeadEnd: Set<String> { get }
  static var importsNeededByTestScaffolding: Set<String> { get }
  static var memoryManagement: String? { get }
  static func coverageRegionSet(regions: [String]) -> [String]
  static var registerCoverageAction: [String] { get }
  static var actionDeclarationsContainerStart: [String]? { get }
  static var actionDeclarationsContainerEnd: [String]? { get }
  static func log(test: String) -> String // Temporary, due to lack of info from “verify”.
  static func testSummary(testCalls: [String]) -> [String]

  // Package
  static func testEntryPoint() -> [String]?
  static var sourceFileName: String { get }
  static func splitFileIfNecessary(_ file: String) -> [String]?
  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws

  // Saying
  static var usesSnakeCase: Bool { get }
  static var permitsParameterLabels: Bool { get }
  static var permitsOverloads: Bool { get }
  static var emptyParameterLabel: UnicodeText { get }
  static var parameterLabelSuffix: UnicodeText { get }
  static var memberPrefix: UnicodeText? { get }
  static var overridePrefix: UnicodeText? { get }
  static var variablePrefix: UnicodeText? { get }
  static var initializerSuffix: UnicodeText? { get }
  static var initializerName: UnicodeText { get }
}

extension Platform {

  static func filterUnsafe(characters: [UInt32]) -> Set<Unicode.Scalar> {
    return Set(
      characters.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          !scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }
  static var allowedIdentifierStartCharacters: Set<Unicode.Scalar> {
    return compute({
      return filterUnsafe(characters: allowedIdentifierStartCharacterPoints)
    }, cachingIn: &_allowedIdentifierStartCharactersCache)
  }
  static var allowedIdentifierContinuationCharacters: Set<Unicode.Scalar> {
    return compute({
      allowedIdentifierStartCharacters.union(
        filterUnsafe(characters: additionalAllowedIdentifierContinuationCharacterPoints)
      )
    }, cachingIn: &_allowedIdentifierContinuationCharactersCache)
  }
  static var disallowedStringLiteralCharacters: Set<Unicode.Scalar> {
    return compute({
      return Set(
        disallowedStringLiteralPoints
          .lazy.compactMap({ Unicode.Scalar($0) })
      )
    }, cachingIn: &_disallowedStringLiteralCharactersCache)
  }
  static func allowedAsIdentifierStart(_ scalar: Unicode.Scalar) -> Bool {
    return (allowedIdentifierStartCharacters.contains(scalar))
    ||
    (
      (
        (allowsAllUnicodeIdentifiers && scalar.properties.isIDStart)
        ||
        (allowedIdentifierStartGeneralCategories.contains(scalar.properties.generalCategory))
      )
      &&
      (!scalar.isVulnerableToNormalization)
    )
  }
  static func allowedAsIdentifierContinuation(_ scalar: Unicode.Scalar) -> Bool {
    return (allowedIdentifierContinuationCharacters.contains(scalar))
    ||
    (
      (
        (allowsAllUnicodeIdentifiers && scalar.properties.isIDContinue)
        ||
        (
          allowedIdentifierStartGeneralCategories.contains(scalar.properties.generalCategory)
          ||
          additionalAllowedIdentifierContinuationGeneralCategories.contains(scalar.properties.generalCategory)
        )
      )
      &&
      (!scalar.isVulnerableToNormalization)
    )
  }
  static func disallowedInStringLiterals(_ scalar: Unicode.Scalar) -> Bool {
    return disallowedStringLiteralCharacters.contains(scalar)
    || Character(scalar).isNewline
    || scalar.isVulnerableToNormalization
  }

  static func sanitize(identifier: UnicodeText, leading: Bool) -> String {
    var result: String = identifier.lazy
      .map({ allowedAsIdentifierContinuation($0) && $0 != "_" ? "\($0)" : "_\($0.hexadecimalCode)" })
      .joined()
    if leading,
      let first = result.scalars.first,
      !allowedAsIdentifierStart(first) {
      result.scalars.removeFirst()
      result.prepend(contentsOf: "_\(first.hexadecimalCode)")
    }
    return result
  }

  static func capLengthOf(identifier: String, index: inout [String: [String: Int]]) -> String {
    guard let limit = identifierLengthLimit,
      identifier.unicodeScalars.count > limit else {
      return identifier
    }
    let truncated = String(String.UnicodeScalarView(identifier.unicodeScalars.prefix(limit)))
    let disambiguator: Int
    if let cached = index[truncated, default: [:]][identifier] {
      disambiguator = cached
    } else {
      disambiguator = index[truncated, default: [:]].count
      index[truncated, default: [:]][identifier] = disambiguator
    }
    return truncated.appending(contentsOf: String(disambiguator, radix: 10))
  }

  static func sanitize(stringLiteral: UnicodeText) -> String {
    return sanitize(stringLiteral: String(stringLiteral))
  }
  static func sanitize(stringLiteral: String) -> String {
    return stringLiteral.unicodeScalars.lazy
      .map({ !disallowedInStringLiterals($0) ? "\($0)" : escapeForStringLiteral(character: $0) })
      .joined()
  }

  static func isSimpleEnumeration(
    _ type: ParsedTypeReference,
    referenceLookup: [ReferenceDictionary]
  ) -> Bool {
    let intermediate: Thing
    switch type {
    case .simple(let simple):
      intermediate = referenceLookup.lookupThing(simple.identifier, components: [])!
    case .compound(let identifier, let components):
      intermediate = referenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      )!
    case .action, .statements, .partReference, .enumerationCase:
      return false
    }
    return intermediate.isSimple
  }
  static func source(for type: ParsedTypeReference, referenceLookup: [ReferenceDictionary]) -> String {
    switch type {
    case .simple(let simple):
      let type = referenceLookup.lookupThing(simple.identifier, components: [])!
      if let native = nativeType(of: type) {
        return String(UnicodeText(native.textComponents.joined()))
      } else if let native = nativeName(of: type) {
        return native
      } else {
        return sanitize(identifier: type.globallyUniqueIdentifier(referenceLookup: referenceLookup), leading: true)
      }
    case .compound(identifier: let identifier, components: let components):
      let type = referenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      )!
      if let native = nativeType(of: type) {
        var result = ""
        for index in native.textComponents.indices {
          result.append(contentsOf: String(native.textComponents[index]))
          if index != native.textComponents.indices.last {
            let type = native.parameters[index].resolvedType!
            result.append(contentsOf: source(for: type, referenceLookup: referenceLookup))
          }
        }
        return repair(compoundNativeType: result)
      } else {
        return sanitize(
          identifier: type.globallyUniqueIdentifier(referenceLookup: referenceLookup),
          leading: true
        )
      }
    case .action(parameters: let actionParameters, returnValue: let actionReturn):
      return actionType(
        parameters: actionParameters
          .lazy.map({ source(for: $0, referenceLookup: referenceLookup) })
          .joined(separator: ", "),
        returnValue:
          actionReturn.map({ source(for: $0, referenceLookup: referenceLookup) })
            ?? emptyReturnTypeForActionType
      )
    case .statements:
      fatalError("Statements have no platform type.")
    case .partReference(container: let container, identifier: _):
      return source(for: container, referenceLookup: referenceLookup)
    case .enumerationCase(enumeration: let enumeration, identifier: _):
      return source(for: enumeration, referenceLookup: referenceLookup)
    }
  }

  static func identifierPrefix(for type: String) -> String {
    return String(String.UnicodeScalarView(type.unicodeScalars.lazy.filter({ allowedAsIdentifierContinuation($0) })))
  }

  static func nativeName(of action: ActionIntermediate, referenceLookup: [ReferenceDictionary]) -> String? {
    if let identifier = action.identifier(for: self, referenceLookup: referenceLookup) {
      if let functionName = StrictString(identifier).prefix(upTo: "(".scalars.literal()) {
        return String(UnicodeText(functionName.contents))
      } else {
        return String(identifier)
      }
    } else {
      return nil
    }
  }
  
  static func nativeIsOverride(action: ActionIntermediate) -> Bool {
    if let name = nativeNameDeclaration(of: action) {
      if let override = overridePrefix {
        return name.starts(with: override)
      }
    }
    return false
  }

  static func nativeIsProperty(action: ActionIntermediate) -> Bool {
    if var name = nativeNameDeclaration(of: action).map({ StrictString($0) }) {
      if let override = overridePrefix.map({ StrictString($0) }),
         name.hasPrefix(override) {
        name.removeFirst(override.count)
      }
      if let variable = variablePrefix {
        return name.starts(with: variable)
      }
    }
    return false
  }

  static func nativeDeclarationIsInitializer(declaration: UnicodeText) -> Bool {
    let parsableDeclaration = StrictString(declaration)
    if let initializer = initializerSuffix.map({ StrictString($0) }),
      (parsableDeclaration.prefix(upTo: " ")?.contents ?? parsableDeclaration[...]).hasSuffix(initializer.literal()) {
      return true
    }
    return false
  }
  static func nativeIsInitializer(action: ActionIntermediate) -> Bool {
    if let name = nativeNameDeclaration(of: action) {
      return nativeDeclarationIsInitializer(declaration: name)
    }
    return false
  }

  static func nativeIsMember(action: ActionIntermediate) -> Bool {
    if var name = nativeNameDeclaration(of: action).map({ StrictString($0) }) {
      if let override = overridePrefix.map({ StrictString($0) }),
         name.hasPrefix(override) {
        name.removeFirst(override.count)
      }
      if let variable = variablePrefix.map({ StrictString($0) }),
         name.hasPrefix(variable) {
        name.removeFirst(variable.count)
      }
      if let member = memberPrefix,
        name.starts(with: member) {
        return true
      }
      if nativeDeclarationIsInitializer(declaration: UnicodeText(name)) {
        return true
      }
    }
    return false
  }

  static func declaration(
    for enumerationCase: CaseIntermediate,
    index: Int,
    simple: Bool,
    parentType: String,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    let name = sanitize(
      identifier: enumerationCase.names.identifier(),
      leading: true
    )
    let contents = enumerationCase.contents
      .map({ source(for: $0, referenceLookup: referenceLookup) })
    return caseDeclaration(
      name: name,
      contents: contents,
      index: index,
      simple: simple,
      parentType: parentType
    )
  }
  static func storageDeclaration(
    for enumerationCase: CaseIntermediate,
    parentType: String,
    referenceLookup: [ReferenceDictionary]
  ) -> String? {
    if !needsSeparateCaseStorage {
      return nil
    }
    guard let contents = enumerationCase.contents
      .map({ source(for: $0, referenceLookup: referenceLookup) }) else {
      return nil
    }
    let name = sanitize(
      identifier: enumerationCase.names.identifier(),
      leading: true
    )
    return caseStorageDeclaration(
      name: name,
      contents: contents,
      parentType: parentType
    )
  }
  static func declaration(
    for thing: Thing,
    externalReferenceLookup: [ReferenceDictionary],
    mode: CompilationMode,
    relocatedActions: inout Set<String>,
    alreadyHandledNativeRequirements: inout Set<String>,
    modulesToSearchForMembers: [ModuleIntermediate]
  ) -> String? {
    if !isTyped,
      thing.cases.isEmpty {
      return nil
    }
    if let native = nativeType(of: thing) {
      return source(for: native.requiredDeclarations, referenceLookup: externalReferenceLookup, alreadyHandled: &alreadyHandledNativeRequirements)
    }
    if !isTyped,
      thing.cases.allSatisfy({ enumerationCase in
        return enumerationCase.referenceAction.flatMap({ nativeImplementation(of: $0) }) != nil
      }) {
      return nil
    }

    let name = nativeName(of: thing) ?? sanitize(
      identifier: thing.globallyUniqueIdentifier(referenceLookup: externalReferenceLookup),
      leading: true
    )
    let access = accessModifier(for: thing.access, memberScope: false)
    var members: [String] = []
    var handledActionDeclarations: Set<String> = []
    for module in modulesToSearchForMembers {
      let referenceLookup = externalReferenceLookup.appending(module.referenceDictionary)
      for action in module.referenceDictionary.allActions(
        filter: { action in
          if !action.isCreation,
             nativeIsMember(action: action) {
            let typeToCompare: ParsedTypeReference
            if nativeIsInitializer(action: action) {
              typeToCompare = action.returnValue!
            } else {
              typeToCompare = action.parameters.ordered(for: nativeNameDeclaration(of: action)!).first!.type
            }
            if name == source(
              for: typeToCompare,
              referenceLookup: referenceLookup
            ) {
              return true
            }
          }
          return false
        },
        sorted: true
      ) {
        if let declaration = self.declaration(
          for: action,
          externalReferenceLookup: referenceLookup,
          mode: mode,
          isAbsorbedMember: true,
          hasBeenRelocated: false,
          alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements
        ) {
          if handledActionDeclarations.insert(declaration.uniquenessDefinition).inserted {
            relocatedActions.insert(String(action.globallyUniqueIdentifier(referenceLookup: referenceLookup)))
            members.append(declaration.full)
          }
        }
      }
    }
    if thing.cases.isEmpty {
      let components = thing.parts.map({ part in
        let name = sanitize(
          identifier: part.names.identifier(),
          leading: true
        )
        let type = source(for: part.contents, referenceLookup: externalReferenceLookup)
        let access = accessModifier(for: part.readAccess, memberScope: true)
        return partDeclaration(
          name: name,
          type: type,
          accessModifier: access,
          noSetter: part.writeAccess == .nowhere
        )
      })
      let specifiedConstructor = externalReferenceLookup.lookupCreation(of: thing)
      let constructorParameters: [String]
      if let specified = specifiedConstructor {
        let orderIdentifier = nativeNameDeclaration(of: specified) ?? specified.names.identifier()
        constructorParameters = specified.parameters.ordered(for: orderIdentifier).map({ parameter in
          return source(for: parameter, referenceLookup: externalReferenceLookup)
        })
      } else {
        constructorParameters = thing.parts.map({ part in
          let name = sanitize(
            identifier: part.names.identifier(),
            leading: true
          )
          let type = source(for: part.contents, referenceLookup: externalReferenceLookup)
          return parameterDeclaration(label: nil, name: name, type: type, isThrough: false)
        })
      }
      let constructorAccess = accessModifier(for: specifiedConstructor?.access ?? .file, memberScope: true)
      let constructorSetters = thing.parts.map({ part in
        let name = sanitize(
          identifier: part.names.identifier(),
          leading: true
        )
        return constructorSetter(name: name)
      })
      return thingDeclaration(
        name: name,
        components: components,
        accessModifier: access,
        constructorParameters: constructorParameters,
        constructorAccessModifier: constructorAccess,
        constructorSetters: constructorSetters,
        otherMembers: members
      )
    } else {
      var cases: [String] = []
      var storageCases: [String] = []
      for enumerationCase in thing.cases {
        cases.append(
          declaration(
            for: enumerationCase,
            index: cases.endIndex,
            simple: thing.isSimple,
            parentType: name,
            referenceLookup: externalReferenceLookup
          )
        )
        if let storage = storageDeclaration(for: enumerationCase, parentType: name, referenceLookup: externalReferenceLookup) {
          storageCases.append(storage)
        }
      }
      return enumerationTypeDeclaration(
        name: name,
        cases: cases,
        accessModifier: access,
        simple: thing.isSimple,
        storageCases: storageCases,
        otherMembers: members
      )
    }
  }

  static func flowCoverageRegistration(
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    statements: Array<StatementIntermediate>.SubSequence
  ) -> String? {
    coverageRegionCounter += 1
    if let coverage = contextCoverageIdentifier,
      statements.first?.isDeadEnd != true {
      let appendedIdentifier = "\(coverage):{\(coverageRegionCounter.inDigits())}"
      return "\n\(self.coverageRegistration(identifier: sanitize(stringLiteral: UnicodeText(appendedIdentifier))))"
    } else {
      return nil
    }
  }

  static func call(scalarLiteral: LiteralIntermediate, normalize: Bool) -> String {
    var contents = scalarLiteral.string
    if normalize {
      contents = contents.decomposedStringWithCompatibilityMapping
    }
    return self.literal(scalars: sanitize(stringLiteral: contents))
  }

  static func call(
    literal: LiteralIntermediate,
    type: Thing,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    isNativeArgument: Bool,
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    extractedArguments: inout [String],
    isArgumentExtraction: Bool,
    isDirectReturn: Bool,
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: String],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode
  ) -> String {
    if let loading = literal.loadingAction(type: type) {
      return call(
        to: loading,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        isNativeArgument: isNativeArgument,
        contextCoverageIdentifier: contextCoverageIdentifier,
        coverageRegionCounter: &coverageRegionCounter,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        extractedArguments: &extractedArguments,
        isDirectReturn: isDirectReturn,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        normalizeNextNestedLiteral: type.names.contains(LiteralIntermediate.unicodeTextName),
        mode: mode
      )
    } else if type.names.contains(LiteralIntermediate.unicodeScalarName) {
      return self.literal(scalar: literal.string.unicodeScalars.first!)
    } else {
      return call(scalarLiteral: literal, normalize: normalizeNextNestedLiteral)
    }
  }

  static func call(
    to reference: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    isNativeArgument: Bool,
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    extractedArguments: inout [String],
    isArgumentExtraction: Bool = false,
    isDirectReturn: Bool,
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: String],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode
  ) -> String {
    if let literal = reference.literal {
      let type = referenceLookup.lookupThing(reference.resolvedResultType!!.key)!
      if !isArgumentExtraction,
        !extractedArguments.isEmpty,
        let native = nativeType(of: type),
        native.release != nil {
        return extractedArguments.removeFirst()
      }
      return call(
        literal: literal,
        type: type,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        isNativeArgument: isNativeArgument,
        contextCoverageIdentifier: contextCoverageIdentifier,
        coverageRegionCounter: &coverageRegionCounter,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        extractedArguments: &extractedArguments,
        isArgumentExtraction: isArgumentExtraction,
        isDirectReturn: isDirectReturn,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        normalizeNextNestedLiteral: normalizeNextNestedLiteral,
        mode: mode
      )
    }
    let signature = reference.arguments.map({ $0.resolvedResultType!! })
    if let inlined = inliningArguments[reference.actionName] {
      return inlined
    } else if reference.passage == .out {
      return String(sanitize(identifier: reference.actionName, leading: true))
    } else if let local = localLookup.lookupAction(
      reference.actionName,
      signature: signature,
      specifiedReturnValue: reference.resolvedResultType,
      externalLookup: referenceLookup
    ) {
      return String(sanitize(identifier: local.names.identifier(), leading: true))
    } else if let parameter = context?.lookupParameter(reference.actionName) {
      let parameterName = nativeName(of: parameter) ?? sanitize(identifier: parameter.names.identifier(), leading: true)
      if parameter.passAction.returnValue?.key.resolving(fromReferenceLookup: referenceLookup)
        == reference.resolvedResultType!?.key.resolving(fromReferenceLookup: referenceLookup) {
        if parameter.isThrough {
          return dereference(
            throughParameter: parameterName,
            forwarding: reference.passage == .through && !isNativeArgument
          )
        } else {
          return parameterName
        }
      } else {
        return call(
          to: parameter.executeAction!,
          bareAction: parameter.executeAction!,
          reference: reference,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          parameterName: parameterName,
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          extractedArguments: &extractedArguments,
          cleanUpCode: &cleanUpCode,
          inliningArguments: [:],
          normalizeNextNestedLiteral: normalizeNextNestedLiteral,
          mode: mode
        )
      }
    } else {
      let bareAction = referenceLookup.lookupAction(
        reference.actionName,
        signature: signature,
        specifiedReturnValue: reference.resolvedResultType
      )!
      let redirectingToCoverageWrapper = mode == .testing && !(context?.isCoverageWrapper ?? false)
      let action = !redirectingToCoverageWrapper
        ? bareAction
        : referenceLookup.lookupAction(
          bareAction.coverageTrackingIdentifier(),
          signature: order(
            signature,
            for: bareAction.parameters.reordering(
              from: reference.actionName,
              to: bareAction.names.identifier()
            )
          ),
          specifiedReturnValue: reference.resolvedResultType
        )!
      if !isDirectReturn,
        !isArgumentExtraction,
        !extractedArguments.isEmpty,
        let result = action.returnValue,
        let type = referenceLookup.lookupThing(result.key),
        let native = nativeType(of: type),
        native.release != nil {
        return extractedArguments.removeFirst()
      }
      var result: [String] = [
        call(
          to: bareAction.isFlow ? bareAction : action,
          bareAction: bareAction,
          reference: reference,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          parameterName: nil,
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          extractedArguments: &extractedArguments,
          cleanUpCode: &cleanUpCode,
          inliningArguments: inliningArguments,
          normalizeNextNestedLiteral: normalizeNextNestedLiteral,
          mode: mode
        )
      ]
      if mode == .testing,
        bareAction.isFlow,
        bareAction.returnValue == nil,
        let coveredIdentifier = action.coveredIdentifier {
        result.prepend(
          coverageRegistration(identifier: sanitize(stringLiteral: coveredIdentifier))
        )
      }
      return result.joined(separator: "\n\(indent)")
    }
  }
  static func call(
    to action: ActionIntermediate,
    bareAction: ActionIntermediate,
    reference: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    parameterName: String?,
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    extractedArguments: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: String],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode
  ) -> String {
    var didUseClashAvoidance = false
    defer {
      if didUseClashAvoidance {
        clashAvoidanceCounter += 1
      }
    }
    if let native = nativeImplementation(of: action) {
      let usedParameters = action.parameters.ordered(for: reference.actionName)
      var accumulator = ""
      var beforeCleanUp: String? = nil
      var local = ReferenceDictionary()
      let nativeExpression = native.expression
      for index in nativeExpression.textComponents.indices {
        accumulator.append(contentsOf: String(nativeExpression.textComponents[index]))
        if index != nativeExpression.textComponents.indices.last {
          let parameter = nativeExpression.parameters[index]
          if let type = parameter.typeInstead {
            let typeSource = source(for: type, referenceLookup: referenceLookup)
            if let next = nativeExpression.parameters[index...].dropFirst().first,
              next.name == "‐" {
              accumulator.append(contentsOf: identifierPrefix(for: typeSource))
            } else {
              accumulator.append(contentsOf: typeSource)
            }
          } else if let enumerationCase = parameter.caseInstead {
            switch enumerationCase {
            case .simple, .compound, .action, .statements, .partReference:
              fatalError("Only enumeration cases should be stored in “caseInstead”.")
            case .enumerationCase(enumeration: let type, identifier: let identifier):
              let reference = caseReference(
                name: sanitize(identifier: identifier, leading: true),
                type: source(for: type, referenceLookup: referenceLookup),
                simple: false,
                ignoringValue: true
              )
              accumulator.append(contentsOf: reference)
            }
          } else {
            let name = parameter.name
            if let argumentIndex = usedParameters.firstIndex(where: { $0.names.contains(name) }) {
              let argument = reference.arguments[argumentIndex]
              switch argument {
              case .action(let actionArgument):
                accumulator.append(
                  contentsOf: call(
                    to: actionArgument,
                    context: context,
                    localLookup: localLookup.appending(local),
                    referenceLookup: referenceLookup,
                    isNativeArgument: true,
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter,
                    clashAvoidanceCounter: &clashAvoidanceCounter,
                    extractedArguments: &extractedArguments,
                    isDirectReturn: false,
                    cleanUpCode: &cleanUpCode,
                    inliningArguments: inliningArguments,
                    normalizeNextNestedLiteral: normalizeNextNestedLiteral,
                    mode: mode
                  )
                )
              case .flow(let statements):
                if mode == .testing,
                   let coverage = flowCoverageRegistration(
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter,
                    statements: statements.statements[...]
                   ) {
                  accumulator.append(coverage)
                }
                accumulator.append("\n")
                accumulator.append(
                  contentsOf: source(
                    for: statements.statements,
                    context: context,
                    localLookup: localLookup.appending(local),
                    coverageRegionCounter: &coverageRegionCounter,
                    clashAvoidanceCounter: &clashAvoidanceCounter,
                    referenceLookup: referenceLookup,
                    inliningArguments: inliningArguments,
                    mode: mode,
                    indentationLevel: 1
                  ).joined(separator: "\n")
                )
                accumulator.append("\n")
              }
              let newActions = argument.localActions()
              for new in newActions {
                _ = local.add(action: new)
              }
              if !newActions.isEmpty {
                local.resolveTypeIdentifiers(externalLookup: referenceLookup.appending(contentsOf: localLookup))
              }
            } else {
              if name == "+" {
                accumulator.append(String(clashAvoidanceCounter))
                didUseClashAvoidance = true
              } else if name == "−" {
                beforeCleanUp = accumulator
                accumulator = ""
              } else {
                if name != "‐" {
                  fatalError()
                }
              }
            }
          }
        }
      }
      if let before = beforeCleanUp {
        cleanUpCode = accumulator
        return before
      } else {
        return accumulator
      }
    } else if action.isMemberWrapper {
      let name = parameterName ?? sanitize(identifier: action.names.identifier(), leading: true)
      if case .partReference = action.returnValue! {
        return name
      } else {
        let type = source(for: action.returnValue!, referenceLookup: referenceLookup)
        return caseReference(
          name: name,
          type: type,
          simple: isSimpleEnumeration(action.returnValue!, referenceLookup: referenceLookup),
          ignoringValue: (action.isFlow && action.isMemberWrapper) || action.isEnumerationValueWrapper
        )
      }
    } else if action.isFlow {
      let parameters = action.parameters.ordered(for: reference.actionName)
      var newInliningArguments: [UnicodeText: String] = [:]
      var locals = ReferenceDictionary()
      for index in parameters.indices {
        let parameter = parameters[index]
        let argument = reference.arguments[index]
        switch argument {
        case .action(let action):
          newInliningArguments[parameter.names.identifier()] = call(
            to: action,
            context: context,
            localLookup: localLookup.appending(locals),
            referenceLookup: referenceLookup,
            isNativeArgument: false,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            extractedArguments: &extractedArguments,
            isDirectReturn: false,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: normalizeNextNestedLiteral,
            mode: mode
          )
          let newActions = action.localActions()
          for local in newActions {
            _ = locals.add(action: local)
          }
          if !newActions.isEmpty {
            locals.resolveTypeIdentifiers(externalLookup: referenceLookup)
          }
        case .flow(let flow):
          var source: [String] = source(
            for: flow.statements,
            context: context,
            localLookup: localLookup.appending(locals),
            coverageRegionCounter: &coverageRegionCounter,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            referenceLookup: referenceLookup,
            inliningArguments: inliningArguments,
            mode: mode,
            indentationLevel: 0
          )
          if mode == .testing,
            let coverage = flowCoverageRegistration(
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            statements: flow.statements[...]
          ) {
            source.prepend(coverage)
          }
          newInliningArguments[parameter.names.identifier()] = source.joined(separator: "\n")
        }
      }
      var newCoverageRegionCounter = 0
      return source(
        for: action.implementation!.statements,
        context: action,
        localLookup: localLookup,
        coverageRegionCounter: &newCoverageRegionCounter,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        referenceLookup: referenceLookup,
        inliningArguments: newInliningArguments,
        mode: mode,
        indentationLevel: 0
      ).joined(separator: "\n")
    } else {
      let name = nativeName(of: action, referenceLookup: referenceLookup)
        ?? parameterName
        ?? sanitize(
          identifier: action.globallyUniqueIdentifier(referenceLookup: referenceLookup),
          leading: true
        )
      if action.isReferenceWrapper {
        let prefix = actionReferencePrefix(isVariable: parameterName != nil) ?? ""
        return "\(prefix)\(name)"
      } else {
        var argumentsArray: [String] = []
        let outputName = nativeNameDeclaration(of: action) ?? bareAction.names.identifier()
        let parameters = bareAction.parameters.ordered(for: outputName)
        let arguments = order(reference.arguments, for: bareAction.parameters.reordering(from: reference.actionName, to: outputName))
        for argumentIndex in arguments.indices {
          let argument = arguments[argumentIndex]
          let parameter = parameters[argumentIndex]
          let parameterLabel = nativeLabel(of: parameter, isCreation: action.isCreation)
            .map({ $0 == "" ? "" : "\($0): " }) ?? ""
          switch argument {
          case .action(let actionArgument):
            if actionArgument.passage == .through {
              argumentsArray.append(
                parameterLabel + passReference(
                  to: call(
                    to: actionArgument,
                    context: context,
                    localLookup: localLookup,
                    referenceLookup: referenceLookup,
                    isNativeArgument: false,
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter,
                    clashAvoidanceCounter: &clashAvoidanceCounter,
                    extractedArguments: &extractedArguments,
                    isDirectReturn: false,
                    cleanUpCode: &cleanUpCode,
                    inliningArguments: inliningArguments,
                    normalizeNextNestedLiteral: normalizeNextNestedLiteral,
                    mode: mode
                  ),
                  forwarding: context?.parameters.parameter(named: actionArgument.actionName)?.isThrough == true,
                  isAddressee: nativeIsMember(action: action) && argumentsArray.isEmpty
                )
              )
            } else {
              argumentsArray.append(
                parameterLabel + call(
                  to: actionArgument,
                  context: context,
                  localLookup: localLookup,
                  referenceLookup: referenceLookup,
                  isNativeArgument: false,
                  contextCoverageIdentifier: contextCoverageIdentifier,
                  coverageRegionCounter: &coverageRegionCounter,
                  clashAvoidanceCounter: &clashAvoidanceCounter,
                  extractedArguments: &extractedArguments,
                  isDirectReturn: false,
                  cleanUpCode: &cleanUpCode,
                  inliningArguments: inliningArguments,
                  normalizeNextNestedLiteral: normalizeNextNestedLiteral,
                  mode: mode
                )
              )
            }
          case .flow:
            fatalError("Statement parameters are only supported in native implementations (so far).")
          }
        }
        if action.isCreation {
          let type = source(for: action.returnValue!, referenceLookup: referenceLookup)
          if infersConstructors {
            argumentsArray = referenceLookup.lookupThing(action.returnValue!.key)!.parts.map { part in
              let index = parameters.firstIndex(where: { $0.names.overlaps(part.names) })!
              return argumentsArray[index]
            }
          }
          let arguments = argumentsArray.joined(separator: ", ")
          return createInstance(of: type, parts: arguments)
        } else {
          let nameStart = name.unicodeScalars.first(where: { $0 != "_" }).map({ String($0) }) ?? ""
          if sanitize(identifier: UnicodeText(nameStart), leading: false) != nameStart {
            return "\(argumentsArray.joined(separator: " \(name) "))"
          } else {
            var result: String = ""
            var modifiedName = name
            if nativeIsInitializer(action: action) {
              modifiedName = source(for: action.returnValue!, referenceLookup: referenceLookup)
            } else if nativeIsMember(action: action) {
              let first = argumentsArray.removeFirst()
              result.append(contentsOf: first)
              if name != "subscript" {
                result.append(contentsOf: ".")
              }
            }
            if nativeIsProperty(action: action) {
              result.append(contentsOf: name)
            } else {
              let arguments = argumentsArray.joined(separator: ", ")
              if name == "subscript" {
                result.append(contentsOf: "[\(arguments)]")
              } else {
                result.append(contentsOf: "\(modifiedName)(\(arguments))")
              }
            }
            return result
          }
        }
      }
    }
  }

  static func argumentsExtractedForReferenceCounting(
    from action: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: String],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode
  ) -> ReferenceCountedReturns {
    var entries = ReferenceCountedReturns()
    extractArgumentsForReferenceCounting(
      from: action,
      context: context,
      localLookup: localLookup,
      referenceLookup: referenceLookup,
      contextCoverageIdentifier: contextCoverageIdentifier,
      coverageRegionCounter: &coverageRegionCounter,
      clashAvoidanceCounter: &clashAvoidanceCounter,
      cleanUpCode: &cleanUpCode,
      inliningArguments: inliningArguments,
      normalizeNextNestedLiteral: normalizeNextNestedLiteral,
      mode: mode,
      entries: &entries
    )
    return entries
  }
  static func extractArgumentsForReferenceCounting(
    from action: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: String],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode,
    entries: inout ReferenceCountedReturns
  ) {
    for argument in action.arguments {
      switch argument {
      case .action(let action):
        if action.passage == .out || action.passage == .through {
          continue
        } else if localLookup.lookupAction(
          action.actionName,
          signature: action.arguments.map({ $0.resolvedResultType!! }),
          specifiedReturnValue: action.resolvedResultType,
          externalLookup: referenceLookup
        ) != nil {
          continue
        } else if context?.lookupParameter(action.actionName) != nil {
          continue
        } else {
          extractArgumentsForReferenceCounting(
            from: action,
            context: context,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: normalizeNextNestedLiteral,
            mode: mode,
            entries: &entries
          )
        }

        if let result = argument.resolvedResultType,
          let actualResult = result,
          let type = referenceLookup.lookupThing(actualResult.key),
          let native = nativeType(of: type),
           let release = native.release {
          clashAvoidanceCounter += 1
          let localName = "local\(clashAvoidanceCounter)"
          let typeName = source(for: actualResult, referenceLookup: referenceLookup)
          let call = self.call(
            to: action,
            context: context,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            isNativeArgument: false,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            extractedArguments: &entries.unused,
            isArgumentExtraction: true,
            isDirectReturn: false,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: normalizeNextNestedLiteral,
            mode: mode
          )
          let releaseExpression = release.textComponents.lazy.map({ String($0) })
            .joined(separator: localName)
          entries.append(
            ReferenceCountedReturn(
              localStorageDeclaration: "\(typeName) \(localName) = \(call);",
              localName: localName,
              releaseStatement: "\(releaseExpression);"
            )
          )
        }
      case .flow:
        break
      }
    }
  }

  static func source(
    for statement: StatementIntermediate,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    followingStatements: Array<StatementIntermediate>.SubSequence,
    clashAvoidanceCounter: inout Int,
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: String],
    existingReferences: inout Set<String>,
    mode: CompilationMode,
    indentationLevel: Int
  ) -> [String] {
    var entry = ""
    if let action = statement.action {
      var referenceList: [String] = []
      if needsReferencePreparation {
        referenceList = statement.passedReferences()
          .filter({ reference in
            return context?.parameters.parameter(named: reference.actionName)?.isThrough != true
          })
          .map({ reference in
            var extracted: [String] = []
            return call(
              to: reference,
              context: context,
              localLookup: localLookup,
              referenceLookup: referenceLookup,
              isNativeArgument: false,
              contextCoverageIdentifier: contextCoverageIdentifier,
              coverageRegionCounter: &coverageRegionCounter,
              clashAvoidanceCounter: &clashAvoidanceCounter,
              extractedArguments: &extracted,
              isDirectReturn: false,
              cleanUpCode: &cleanUpCode,
              inliningArguments: inliningArguments,
              normalizeNextNestedLiteral: false,
              mode: mode
            )
          })
        for reference in referenceList {
          if let preparation = prepareReference(
            to: reference,
            update: existingReferences.contains(reference)
          ) {
            entry.append(preparation)
          }
        }
      }
      let extractedArguments = argumentsExtractedForReferenceCounting(
        from: action,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        contextCoverageIdentifier: contextCoverageIdentifier,
        coverageRegionCounter: &coverageRegionCounter,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        normalizeNextNestedLiteral: false,
        mode: mode
      )
      if !extractedArguments.all.isEmpty {
        for argument in extractedArguments.all {
          entry.append(argument.localStorageDeclaration.appending("\n"))
          cleanUpCode.prepend(contentsOf: argument.releaseStatement.appending("\n"))
        }
      }
      if statement.isReturn {
        if referenceList.isEmpty {
          entry.append(contentsOf: "return ")
        } else {
          entry.append(
            contentsOf: returnDelayStorage(
              type: action.resolvedResultType!
                .map({ source(for: $0, referenceLookup: referenceLookup) })
            )
          )
        }
      }
      let before = coverageRegionCounter
      var remainingExtractedArguments = extractedArguments.unused
      entry.append(
        contentsOf: self.statement(
          expression: call(
            to: action,
            context: context,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            isNativeArgument: false,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            extractedArguments: &remainingExtractedArguments,
            isDirectReturn: statement.isReturn,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: false,
            mode: mode
          )
        )
      )
      if mode == .testing,
         coverageRegionCounter != before,
         let coverage = flowCoverageRegistration(
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter,
          statements: followingStatements
         ) {
        entry.append(coverage)
      }
      for reference in referenceList.reversed() {
        if let unpack = unpackReference(to: reference) {
          entry.append(unpack)
        }
      }
      if !referenceList.isEmpty {
        if statement.isReturn {
          entry.append(contentsOf: delayedReturn)
        }
        for reference in referenceList {
          existingReferences.insert(reference)
        }
      }
    } else {
      entry.append(contentsOf: deadEnd())
    }
    let presentIndent = String(repeating: indent, count: indentationLevel)
    entry.scalars.replaceMatches(for: "\n".scalars.literal(), with: "\n\(presentIndent)".scalars)
    return entry.prepending(contentsOf: presentIndent).components(separatedBy: "\n")
  }

  static func source(
    for parameter: ParameterIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    let name = nativeName(of: parameter) ?? sanitize(identifier: parameter.names.identifier(), leading: true)
    if !isTyped {
      return name
    } else {
      switch parameter.type {
      case .simple, .compound:
        let label = nativeLabel(of: parameter, isCreation: false)
        let typeSource = source(for: parameter.type, referenceLookup: referenceLookup)
        return parameterDeclaration(label: label, name: name, type: typeSource, isThrough: parameter.isThrough)
      case .action(parameters: let actionParameters, returnValue: let actionReturn):
        let label = nativeLabel(of: parameter, isCreation: false)
        let parameters = actionParameters
          .lazy.map({ source(for: $0, referenceLookup: referenceLookup) })
          .joined(separator: ", ")
        let returnValue: String
        if let specified = actionReturn {
          returnValue = source(for: specified, referenceLookup: referenceLookup)
        } else {
          returnValue = emptyReturnTypeForActionType
        }
        return parameterDeclaration(
          label: label,
          name: name,
          parameters: parameters,
          returnValue: returnValue
        )
      case .statements:
        fatalError("Statements should have been handled elsewhere.")
      case .partReference:
        fatalError("Part references should have been handled elsewhere.")
      case .enumerationCase:
        fatalError("Enumeration cases should have been handled elsewhere.")
      }
    }
  }

  static func forwardDeclaration(
    for action: ActionIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String? {
    if nativeImplementation(of: action) != nil
      || action.isMemberWrapper {
      return nil
    }

    let name = sanitize(
      identifier: action.globallyUniqueIdentifier(referenceLookup: referenceLookup),
      leading: true
    )
    let parameters = action.parameters.ordered(for: action.names.identifier())
      .lazy.map({ source(for: $0, referenceLookup: referenceLookup) })
      .joined(separator: ", ")

    let returnValue: String?
    if let specified = action.returnValue {
      returnValue = source(for: specified, referenceLookup: referenceLookup)
    } else {
      returnValue = emptyReturnType
    }

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0, isProperty: false) })

    return forwardActionDeclaration(
      name: name,
      parameters: parameters,
      returnSection: returnSection
    )
  }

  static func source(
    for statements: [StatementIntermediate],
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    referenceLookup: [ReferenceDictionary],
    inliningArguments: [UnicodeText: String],
    mode: CompilationMode,
    indentationLevel: Int
  ) -> [String] {
    var locals = ReferenceDictionary()
    var cleanUpCode = ""
    var existingReferences: Set<String> = []
    var inOrder = statements.indices.flatMap({ entryIndex in
      let entry = statements[entryIndex]
      let result = source(
        for: entry,
        context: context,
        localLookup: localLookup.appending(locals),
        referenceLookup: referenceLookup.appending(locals),
        contextCoverageIdentifier: context?.coverageRegionIdentifier(referenceLookup: referenceLookup),
        coverageRegionCounter: &coverageRegionCounter,
        followingStatements: statements[entryIndex...].dropFirst(),
        clashAvoidanceCounter: &clashAvoidanceCounter,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        existingReferences: &existingReferences,
        mode: mode,
        indentationLevel: indentationLevel
      )
      let newActions = entry.localActions()
      for local in newActions {
        _ = locals.add(action: local)
      }
      if !newActions.isEmpty {
        locals.resolveTypeIdentifiers(externalLookup: referenceLookup)
      }
      return result
    })
    if inOrder.isEmpty {
      inOrder.append(cleanUpCode)
    } else {
      if !cleanUpCode.isEmpty {
        inOrder[inOrder.indices.last!].append(contentsOf: "\n" + cleanUpCode)
      }
    }
    return inOrder
  }

  static func declaration(
    for action: ActionIntermediate,
    externalReferenceLookup: [ReferenceDictionary],
    mode: CompilationMode,
    isAbsorbedMember: Bool,
    hasBeenRelocated: Bool,
    alreadyHandledNativeRequirements: inout Set<String>
  ) -> UniqueDeclaration? {
    if action.isMemberWrapper {
      return nil
    }
    if let native = nativeImplementation(of: action) {
      if isAbsorbedMember {
        return nil
      } else {
        return source(
          for: native.requiredDeclarations,
          referenceLookup: externalReferenceLookup,
          alreadyHandled: &alreadyHandledNativeRequirements
        ).map { UniqueDeclaration(full: $0, uniquenessDefinition: $0) }
      }
    }
    guard !hasBeenRelocated else {
      return nil
    }

    guard let actionImplementation = action.implementation else {
      // creation
      return nil
    }

    let name = nativeName(of: action, referenceLookup: externalReferenceLookup)
      ?? sanitize(
        identifier: action.globallyUniqueIdentifier(referenceLookup: externalReferenceLookup),
        leading: true
      )
    let isOverride = nativeIsOverride(action: action)
    let isProperty = nativeIsProperty(action: action)
    let isInitializer = nativeIsInitializer(action: action)

    var parameterEntries = action.parameters.ordered(
      for: nativeNameDeclaration(of: action) ?? action.names.identifier()
    )
    var parentType: String?
    var isMutating = false
    if nativeIsMember(action: action),
      !isInitializer {
      let first = parameterEntries.removeFirst()
      isMutating = first.isThrough
      parentType = source(for: first.type, referenceLookup: externalReferenceLookup)
    }
    let parameters: String = parameterEntries
      .lazy.map({ source(for: $0, referenceLookup: externalReferenceLookup) })
      .joined(separator: ", ")

    let returnValue: String?
    if !isInitializer,
      let specified = action.returnValue {
      returnValue = source(for: specified, referenceLookup: externalReferenceLookup)
    } else {
      returnValue = emptyReturnType
    }

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0, isProperty: isProperty) })

    let access = accessModifier(for: action.access, memberScope: false)

    let coverageRegistration: String?
    if mode == .testing,
      let identifier = action.coveredIdentifier {
      coverageRegistration = "\(indent)\(self.coverageRegistration(identifier: sanitize(stringLiteral: identifier)))"
    } else {
      coverageRegistration = nil
    }
    var coverageRegionCounter = 0
    var clashAvoidanceCounter = 0
    let implementation = source(
      for: actionImplementation.statements,
      context: action,
      localLookup: [],
      coverageRegionCounter: &coverageRegionCounter,
      clashAvoidanceCounter: &clashAvoidanceCounter,
      referenceLookup: externalReferenceLookup.appending(
        action.parameterReferenceDictionary(externalLookup: externalReferenceLookup)
      ),
      inliningArguments: [:],
      mode: mode,
      indentationLevel: 1
    )
    return actionDeclaration(
      name: name,
      parameters: parameters,
      returnSection: returnSection,
      accessModifier: access,
      coverageRegistration: coverageRegistration,
      implementation: implementation,
      parentType: parentType,
      isMutating: isMutating,
      isAbsorbedMember: isAbsorbedMember,
      isOverride: isOverride,
      propertyInstead: isProperty,
      initializerInstead: isInitializer
    )
  }

  static func sayingIdentifier(for test: TestIntermediate) -> String {
    return test.location.lazy
      .map({ String($0.identifier()) })
      .joined(separator: ":")
  }
  static func identifier(for test: TestIntermediate, leading: Bool) -> String {
    return test.location.lazy.enumerated()
      .map({ sanitize(identifier: $1.identifier(), leading: leading && $0 == 0) })
      .joined(separator: "_")
  }

  static func source(
    of test: TestIntermediate,
    referenceLookup: [ReferenceDictionary],
    identifierIndex: inout [String: [String: Int]]
  ) -> String {
    var coverageRegionCounter = 0
    var clashAvoidanceCounter = 0
    return actionDeclaration(
      name: capLengthOf(identifier: "run_\(identifier(for: test, leading: false))", index: &identifierIndex),
      parameters: "",
      returnSection: emptyReturnType.flatMap({ self.returnSection(with: $0, isProperty: false) }),
      accessModifier: nil,
      coverageRegistration: nil,
      implementation: source(
        for: test.statements,
        context: nil,
        localLookup: [],
        coverageRegionCounter: &coverageRegionCounter,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        referenceLookup: referenceLookup,
        inliningArguments: [:],
        mode: .testing,
        indentationLevel: 0
      ),
      parentType: nil,
      isMutating: false,
      isAbsorbedMember: false,
      isOverride: false,
      propertyInstead: false,
      initializerInstead: false
    ).full
  }

  static func call(test: TestIntermediate, identifierIndex: inout [String: [String: Int]]) -> [String] {
    let name = capLengthOf(identifier: "run_\(identifier(for: test, leading: false))", index: &identifierIndex)
    return [
      log(test: sayingIdentifier(for: test)),
      log(test: name),
      statement(expression: "\(name)()")
    ]
  }

  static func nativeImports(for referenceDictionary: ReferenceDictionary) -> Set<String> {
    var imports: Set<String> = []
    for thing in referenceDictionary.allThings() {
      for requiredImport in nativeType(of: thing)?.requiredImports ?? [] {
        imports.insert(String(requiredImport))
      }
    }
    for action in referenceDictionary.allActions() {
      for requiredImport in nativeImplementation(of: action)?.requiredImports ?? [] {
        imports.insert(String(requiredImport))
      }
    }
    return imports
  }

  static func coverageRegions(for module: ModuleIntermediate, moduleWideImports: [ReferenceDictionary]) -> Set<UnicodeText> {
    let moduleReferenceLookup = module.referenceDictionary
    let allLookup = moduleWideImports.appending(moduleReferenceLookup)
    let actionRegions: [UnicodeText] = moduleReferenceLookup.allActions()
      .lazy.filter({ $0.deservesTesting })
      .lazy.flatMap({ $0.allCoverageRegionIdentifiers(referenceLookup: allLookup, skippingSubregions: nativeImplementation(of: $0) != nil) })
    let choiceRegions: [UnicodeText] = moduleReferenceLookup.allAbilities()
      .lazy.flatMap({ $0.allDefaults() })
      .lazy.flatMap({ $0.allCoverageRegionIdentifiers(referenceLookup: allLookup, skippingSubregions: nativeImplementation(of: $0) != nil) })
    return Set([
      actionRegions,
      choiceRegions
    ].joined())
  }

  static func source(
    for requirement: NativeRequirementImplementationIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    var line = ""
    for index in requirement.textComponents.indices {
      line.append(contentsOf: String(requirement.textComponents[index]))
      if index != requirement.textComponents.indices.last {
        let parameter = requirement.parameters[index]
        if parameter.name != "‐" {
          var type = source(for: parameter.resolvedType!, referenceLookup: referenceLookup)
          if let next = requirement.parameters[index...].dropFirst().first,
            next.name == "‐" {
            type = identifierPrefix(for: type)
          }
          line.append(contentsOf: type)
        }
      }
    }
    return line
  }
  static func source(
    for nativeRequirements: [NativeRequirementImplementationIntermediate],
    referenceLookup: [ReferenceDictionary],
    alreadyHandled: inout Set<String>
  ) -> String? {
    var result: [String] = []
    for declaration in nativeRequirements {
      let line = source(for: declaration, referenceLookup: referenceLookup)
      if alreadyHandled.insert(line).inserted,
        !isAlgorithmicallyPreexistingNativeRequirement(source: line) {
        result.append(line)
      }
    }
    if result.isEmpty {
      return nil
    } else {
      return result.joined(separator: "\n")
    }
  }

  static func typesSource(
    for module: ModuleIntermediate,
    moduleWideImports: [ReferenceDictionary],
    mode: CompilationMode,
    relocatedActions: inout Set<String>,
    alreadyHandledNativeRequirements: inout Set<String>,
    modulesToSearchForMembers: [ModuleIntermediate]
  ) -> String {
    var result: [String] = []
    let moduleReferenceLookup = moduleWideImports.appending(module.referenceDictionary)
    let allThings = module.referenceDictionary.allThings(sorted: true)
    for thing in allThings {
      if let declaration = self.declaration(
        for: thing,
        externalReferenceLookup: moduleReferenceLookup,
        mode: mode,
        relocatedActions: &relocatedActions,
        alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements,
        modulesToSearchForMembers: modulesToSearchForMembers
      ) {
        result.append(contentsOf: [
          "",
          declaration
        ])
      }
    }
    return result.joined(separator: "\n")
  }

  static func actionsSource(
    for module: ModuleIntermediate,
    mode: CompilationMode,
    moduleWideImports: [ReferenceDictionary],
    relocatedActions: Set<String>,
    alreadyHandledNativeRequirements: inout Set<String>,
    alreadyHandledActionDeclarations: inout Set<String>,
    identifierIndex: inout [String: [String: Int]]
  ) -> String {
    var result: [String] = []
    let moduleReferenceLookup = module.referenceDictionary
    let referenceLookup = moduleWideImports.appending(moduleReferenceLookup)
    let allActions = moduleReferenceLookup.allActions(sorted: true)
    if needsForwardDeclarations {
      for action in allActions where !action.isFlow {
        if let declaration = forwardDeclaration(for: action, referenceLookup: referenceLookup) {
          result.append(contentsOf: [
            "",
            declaration
          ])
        }
      }
    }
    for action in allActions where !action.isFlow {
      if let declaration = self.declaration(
        for: action,
        externalReferenceLookup: referenceLookup,
        mode: mode,
        isAbsorbedMember: false,
        hasBeenRelocated: relocatedActions
          .contains(String(action.globallyUniqueIdentifier(referenceLookup: referenceLookup))),
        alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements
      ) {
        if alreadyHandledActionDeclarations.insert(declaration.uniquenessDefinition).inserted {
          result.append(contentsOf: [
            "",
            declaration.full
          ])
        }
      }
    }
    if mode == .testing {
      let allTests = module.allTests(sorted: true)
      for test in allTests {
        result.append("")
        result.append(source(of: test, referenceLookup: referenceLookup, identifierIndex: &identifierIndex))
      }
    }
    return result.joined(separator: "\n")
  }

  static func source(
    for modules: [ModuleIntermediate],
    mode: CompilationMode,
    moduleWideImports: [ModuleIntermediate]
  ) -> String {
    let moduleWideImportDictionary = moduleWideImports.map { $0.referenceDictionary }
    var alreadyHandledNativeRequirements: Set<String> = preexistingNativeRequirements

    var result: [String] = []

    if let settings = fileSettings {
      result.append(settings)
      result.append("")
    }

    var imports: Set<String> = []
    for module in modules {
      imports.formUnion(nativeImports(for: module.referenceDictionary))
    }
    imports.formUnion(importsNeededByMemoryManagement)
    imports.formUnion(importsNeededByDeadEnd)
    imports.formUnion(importsNeededByTestScaffolding)
    if !imports.isEmpty {
      for importTarget in imports.sorted() {
        result.append(statementImporting(importTarget))
      }
      result.append("")
    }

    if let memoryManagement = memoryManagement {
      result.append(memoryManagement)
      result.append("")
    }

    if mode == .testing {
      var regionSet: Set<UnicodeText> = []
      for module in modules {
        regionSet.formUnion(self.coverageRegions(for: module, moduleWideImports: moduleWideImportDictionary))
      }
      let regions = regionSet
        .sorted(by: { $0.lexicographicallyPrecedes($1) })
        .map({ sanitize(stringLiteral: $0) })
      result.append(contentsOf: coverageRegionSet(regions: regions))
      result.append(contentsOf: registerCoverageAction)
    }

    var relocatedActions: Set<String> = []
    for module in modules {
      result.append(
        typesSource(
          for: module,
          moduleWideImports: moduleWideImportDictionary,
          mode: mode,
          relocatedActions: &relocatedActions,
          alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements,
          modulesToSearchForMembers: modules
        )
      )
    }

    if let start = actionDeclarationsContainerStart {
      result.append("")
      result.append(contentsOf: start)
    }
    var alreadyHandledActionDeclarations: Set<String> = []
    var identifierIndex: [String: [String: Int]] = [:]
    for module in modules {
      result.append(
        self.actionsSource(
          for: module,
          mode: mode,
          moduleWideImports: moduleWideImportDictionary,
          relocatedActions: relocatedActions,
          alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements,
          alreadyHandledActionDeclarations: &alreadyHandledActionDeclarations,
          identifierIndex: &identifierIndex
        )
      )
    }
    if mode == .testing {
      var allTests: [TestIntermediate] = []
      for module in modules {
        allTests.append(contentsOf: module.allTests(sorted: true))
      }
      result.append("")
      result.append(contentsOf: testSummary(testCalls: allTests.flatMap({ call(test: $0, identifierIndex: &identifierIndex) })))
    }
    if let end = actionDeclarationsContainerEnd {
      result.append(contentsOf: end)
    }

    return result.joined(separator: "\n").appending("\n")
  }

  static func splitFileIfNecessary(_ file: String) -> [String]? {
    return nil
  }

  static func preparedDirectory(for package: Package) -> URL {
    return package.constructionDirectory
      .appendingPathComponent(self.directoryName)
  }
  static func productsDirectory(for package: Package) -> URL {
    return package.productsDirectory
      .appendingPathComponent(self.directoryName)
  }

  static func prepare(
    package: Package,
    mode: CompilationMode,
    entryPoints: Set<UnicodeText>? = nil,
    location: URL? = nil
  ) throws {
    let sourceModules = try package.modules()
    var noEntryPoints: Set<UnicodeText>? = nil
    let sayingModule = sourceModules.first(where: { $0.isSayingModule })
    let builtSayingModule = try sayingModule?.build(
      mode: mode == .release ? .dependency : mode,
      entryPoints: &noEntryPoints,
      moduleWideImports: []
    )
    var entryPoints = entryPoints
    var builtModules = try sourceModules
      .lazy.filter({ !$0.isSayingModule })
      .map({ module in
        return try module.build(
          mode: mode,
          entryPoints: &entryPoints,
          moduleWideImports: builtSayingModule.map({ [$0] }) ?? []) }
      )
    if let saying = sayingModule {
      builtModules.prepend(
        try saying.build(
          mode: mode,
          entryPoints: &entryPoints,
          moduleWideImports: []
        )
      )
    }

    var source: [String] = [
      self.source(for: builtModules, mode: mode, moduleWideImports: builtSayingModule.map({ [$0] }) ?? [])
    ]

    var dependencies: Set<String> = []
    for module in builtModules {
      dependencies.formUnion(nativeImports(for: module.referenceDictionary))
    }
    dependencies.formUnion(importsNeededByTestScaffolding)

    switch mode {
    case .testing, .debugging, .dependency:
      if let entryPoint = testEntryPoint() {
        source.append("")
        source.append(contentsOf: entryPoint)
      }
      let constructionDirectory = location ?? preparedDirectory(for: package)
      let completedSource = source.joined(separator: "\n").appending("\n")
      let sourceFileURL = constructionDirectory.appendingPathComponent(sourceFileName)
      if let split = splitFileIfNecessary(completedSource) {
        let fileExtension = sourceFileURL.pathExtension
        let withoutExtension = sourceFileURL.deletingPathExtension()
        let name = withoutExtension.lastPathComponent
        let directory = withoutExtension.deletingLastPathComponent()
        for (index, part) in split.enumerated() {
          try part.save(
            to: directory.appendingPathComponent("\(name)\(index)").appendingPathExtension(fileExtension)
          )
        }
      } else {
        try completedSource.save(to: sourceFileURL)
      }
      try createOtherProjectContainerFiles(projectDirectory: constructionDirectory, dependencies: dependencies.sorted())
    case .release:
      let productsDirectory = location ?? productsDirectory(for: package)
      var joined = source.joined(separator: "\n").appending("\n")
      while joined.first == "\n" {
        joined.removeFirst()
      }
      while joined.hasSuffix("\n\n") {
        joined.removeLast()
      }
      try joined
        .save(to: productsDirectory)
    }
  }
}
