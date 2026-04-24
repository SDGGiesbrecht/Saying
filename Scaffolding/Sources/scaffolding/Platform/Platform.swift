import Foundation

import SDGText

protocol Platform {
  // Miscellaneous
  static var directoryName: String { get }
  static var indent: String { get }
  static var fileSizeLimit: Int? { get }

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
  static var reservedIdentifiers: Set<UnicodeText> { get }
  static var identifierLengthLimit: Int? { get }
  static func escapeForStringLiteral(character: Unicode.Scalar) -> String
  static func literal(scalars: String, escaped: String) -> String
  static func literal(scalar: Unicode.Scalar) -> String
  static func literal(number: String, typeNames: Set<UnicodeText>) -> String
  static func literal(byte: String) -> String
  static func literal(unicodeScalarNumericalValue: String) -> String
  static func numberedParameter(position: Int, type: String?) -> String

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
  static func nativeNameDeclaration(of thing: Thing) -> UnicodeText?
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate?
  static func repair(compoundNativeType: String) -> String
  static func actionType(parameters: String, returnValue: String) -> String
  static func actionReferencePrefix(isVariable: Bool) -> String?
  static var infersConstructors: Bool { get }
  static func detachDeclaration(
    name: String,
    copyOld: String,
    releaseOld: String
  ) -> String
  static func thingDeclaration(
    name: String,
    components: [String],
    accessModifier: String?,
    constructorParameters: [String],
    constructorAccessModifier: String?,
    constructorSetters: [String],
    otherMembers: [String],
    isReferenceCounted: Bool,
    synthesizeReferenceCounting: Bool,
    componentHolds: [String],
    componentReleases: [String],
    copyOld: String?,
    releaseOld: String?
  ) -> String?
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    accessModifier: String?,
    simple: Bool,
    storageCases: [String],
    otherMembers: [String],
    isReferenceCounted: Bool,
    synthesizeReferenceCounting: Bool,
    componentHolds: [(String, String)],
    componentReleases: [(String, String)],
    copyOld: String?,
    releaseOld: String?
  ) -> String
  static func synthesizedHold(on thing: String) -> NativeActionExpressionIntermediate?
  static func synthesizedRelease(of thing: String) -> NativeActionExpressionIntermediate?
  static func synthesizedCopy(of thing: String) -> NativeActionExpressionIntermediate?
  static func synthesizedDetachment(from thing: String) -> NativeActionExpressionIntermediate?

  // Actions
  static func nativeNameDeclaration(of action: ActionIntermediate) -> UnicodeText?
  static func nativeName(of parameter: ParameterIntermediate) -> String?
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String?
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate?
  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String
  static func createInstance(of type: String, parts: String) -> String
  static func constructorSetter(name: String) -> String
  static func localStorage(named name: String, ofType type: String, containing contents: String) -> String
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
  static func coverageRegistration(index: Int) -> String
  static func statement(expression: String) -> String
  static func deadEnd() -> String
  static func returnDelayStorage(type: String?) -> String
  static var delayedReturn: String { get }
  static var functionImplementationSizeLimit: Int? { get }
  static var localConstantKeyword: String? { get }
  static var actionContinuationKeyword: String? { get }
  static func parameter(toContinueLocal local: String) -> String
  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    accessModifier: String?,
    coverageRegistration: String?,
    implementation: [String],
    parentType: String?,
    isStatic: Bool,
    isMutating: Bool,
    isAbsorbedMember: Bool,
    isOverride: Bool,
    propertyInstead: Bool,
    initializerInstead: Bool,
    extractedDeclarations: [String]
  ) -> UniqueDeclaration
  static var needsFunctionLiteralsExtracted: Bool { get }
  static func functionLiteral(
    assignedName: String?,
    parameters: String,
    parameterTypes: String,
    returnType: String?,
    implementation: [String]
  ) -> String
  static func wrap(
    passedFunction: String,
    rearrangingParametersFrom fromOutside: String,
    to forFurtherIn: String,
    wrapperName: String?,
    returnType: String?
  ) -> String

  // Imports
  static var fileSettings: String? { get }
  static func statementImporting(_ importTarget: String) -> String

  // Native Requirements
  static var preexistingNativeRequirements: Set<String> { get }
  static func isAlgorithmicallyPreexistingNativeRequirement(source: String) -> Bool

  // Module
  static var importsNeededByDeadEnd: Set<String> { get }
  static var importsNeededByTestScaffolding: Set<String> { get }
  static var currentTestVariable: String { get }
  static func coverageRegionIndex(regions: [String]) -> [String]
  static var registerCoverageAction: [String] { get }
  static var actionDeclarationsContainerStart: [String]? { get }
  static var actionDeclarationsContainerEnd: [String]? { get }
  static func register(test: String) -> String
  static func testSummary(testCalls: [String]) -> [String]

  // Package
  static func testEntryPoint() -> [String]?
  static var sourceFileName: String { get }
  static func postprocessFileSplit(_ file: String) -> String
  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws

  // Saying
  static var usesSnakeCase: Bool { get }
  static var permitsParameterLabels: Bool { get }
  static var permitsOverloads: Bool { get }
  static var emptyParameterLabel: UnicodeText { get }
  static var parameterLabelSuffix: UnicodeText { get }
  static var memberPrefix: UnicodeText? { get }
  static var staticMemberPrefix: UnicodeText? { get }
  static var overridePrefix: UnicodeText? { get }
  static var variablePrefix: UnicodeText? { get }
  static var initializerSuffix: UnicodeText? { get }
  static var initializerName: UnicodeText { get }
}

func existsForAnyPlatform<T>(
  c: T?,
  cSharp: T?,
  javaScript: T?,
  kotlin: T?,
  swift: T?
) -> Bool {
  return c ?? cSharp ?? javaScript ?? kotlin ?? swift != nil
}

func impossibleOnAnyPlatform(
  c: NativeActionImplementationIntermediate?,
  cSharp: NativeActionImplementationIntermediate?,
  javaScript: NativeActionImplementationIntermediate?,
  kotlin: NativeActionImplementationIntermediate?,
  swift: NativeActionImplementationIntermediate?
) -> Bool {
  for native in [c, cSharp, javaScript, kotlin, swift] {
    if native?.expression.textComponents == [""] {
      return true
    }
  }
  return false
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

  static func sanitize(identifier: UnicodeText, leading: Bool, entire: Bool) -> String {
    var result: String = identifier.lazy
      .map({ allowedAsIdentifierContinuation($0) && $0 != "_" ? "\($0)" : "_\($0.hexadecimalCode)" })
      .joined()
    if leading,
      let first = result.scalars.first,
      !allowedAsIdentifierStart(first) {
      result.scalars.removeFirst()
      result.prepend(contentsOf: "_\(first.hexadecimalCode)")
    }
    if entire && reservedIdentifiers.contains(UnicodeText(result)) {
      let last = result.scalars.removeLast()
      result.append(contentsOf: "_\(last.hexadecimalCode)")
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

  static func nativeName(of thing: Thing, referenceLookup: [ReferenceDictionary]) -> String? {
    if let identifier = thing.identifier(for: self, referenceLookup: referenceLookup) {
      return String(identifier)
    } else {
      return nil
    }
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
  static func source(
    for native: NativeThingImplementationIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    var result = ""
    for index in native.textComponents.indices {
      result.append(contentsOf: String(native.textComponents[index]))
      if index != native.textComponents.indices.last {
        let parameter = native.parameters[index]
        var type = source(for: parameter.resolvedType!, referenceLookup: referenceLookup)
        if parameter.sanitizedForIdentifier {
          type = identifierPrefix(for: type)
        }
        result.append(contentsOf: type)
      }
    }
    return repair(compoundNativeType: result)
  }
  static func source(for type: ParsedTypeReference, referenceLookup: [ReferenceDictionary]) -> String {
    switch type {
    case .simple(let simple):
      let type = referenceLookup.lookupThing(simple.identifier, components: [])!
      if let native = nativeType(of: type) {
        return String(UnicodeText(native.textComponents.joined()))
      } else if let native = nativeName(of: type, referenceLookup: referenceLookup) {
        return native
      } else {
        return sanitize(identifier: type.globallyUniqueIdentifier(referenceLookup: referenceLookup), leading: true, entire: true)
      }
    case .compound(identifier: let identifier, components: let components):
      let type = referenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      )!
      if let native = nativeType(of: type) {
        return source(for: native, referenceLookup: referenceLookup)
      } else if let native = nativeName(of: type, referenceLookup: referenceLookup) {
        return native
      } else {
        return sanitize(
          identifier: type.globallyUniqueIdentifier(referenceLookup: referenceLookup),
          leading: true,
          entire: true
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
    if var name = nativeNameDeclaration(of: action) {
      if let override = overridePrefix,
         name.starts(with: override) {
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
    if let initializer = initializerSuffix,
       (parsableDeclaration.prefix(upTo: " ")?.contents ?? parsableDeclaration[...]).hasSuffix(StrictString(initializer).literal()) {
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
    if var name = nativeNameDeclaration(of: action) {
      if let override = overridePrefix,
         name.starts(with: override) {
        name.removeFirst(override.count)
      }
      if let variable = variablePrefix,
         name.starts(with: variable) {
        name.removeFirst(variable.count)
      }
      if let member = memberPrefix,
        name.starts(with: member) {
        return true
      }
      if nativeDeclarationIsInitializer(declaration: name) {
        return true
      }
    }
    return false
  }

  static func nativeIsStaticMember(action: ActionIntermediate) -> Bool {
    if var name = nativeNameDeclaration(of: action) {
      if nativeIsInitializer(action: action) {
        return false
      }

      if let variable = variablePrefix,
         name.starts(with: variable) {
        name.removeFirst(variable.count)
      }
      if let member = staticMemberPrefix,
        name.starts(with: member) {
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
      leading: true,
      entire: true
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
      leading: true,
      entire: true
    )
    return caseStorageDeclaration(
      name: name,
      contents: contents,
      parentType: parentType
    )
  }
  static func copyOld(
    thing: Thing,
    name: String,
    externalReferenceLookup: [ReferenceDictionary]
  ) -> String? {
    guard thing.requiresCleanUp == true,
      let copy = nativeType(of: thing)?.copy ?? synthesizedCopy(of: name) else {
      return nil
    }
    return apply(
      nativeReferenceCountingAction: copy,
      around: "old",
      referenceLookup: externalReferenceLookup
    )
  }
  static func releaseOld(
    thing: Thing,
    name: String,
    externalReferenceLookup: [ReferenceDictionary]
  ) -> String? {
    guard thing.requiresCleanUp == true,
      let release = nativeType(of: thing)?.release ?? synthesizedRelease(of: name) else {
      return nil
    }
    return apply(
      nativeReferenceCountingAction: release,
      around: "old",
      referenceLookup: externalReferenceLookup
    )
  }
  static func declaration(
    for thing: Thing,
    externalReferenceLookup: [ReferenceDictionary],
    mode: CompilationMode,
    relocatedActions: inout Set<String>,
    alreadyHandledNativeRequirements: inout Set<String>,
    coverageIndex: [UnicodeText: Int],
    anonymousCounter: inout Int,
    modulesToSearchForMembers: [ModuleIntermediate]
  ) -> String? {
    if !isTyped,
      thing.cases.isEmpty {
      return nil
    }
    if let native = nativeType(of: thing) {
      var result: [String] = []
      if let required = source(
        for: native.requiredDeclarations,
        referenceLookup: externalReferenceLookup,
        alreadyHandled: &alreadyHandledNativeRequirements
      ) {
        result.append(required)
      }
      if thing.requiresCleanUp == true {
        let name: String = source(for: native, referenceLookup: externalReferenceLookup)
        if let copy = copyOld(thing: thing, name: name, externalReferenceLookup: externalReferenceLookup),
          let release = releaseOld(
            thing: thing,
            name: name,
            externalReferenceLookup: externalReferenceLookup
          ) {
          let detach = detachDeclaration(
            name: name,
            copyOld: copy,
            releaseOld: release
          )
          if alreadyHandledNativeRequirements.insert(detach).inserted {
            result.append(detach)
          }
        }
      }
      return result.isEmpty ? nil : result.joined(separator: "\n\n")
    }
    if !isTyped,
      thing.cases.allSatisfy({ enumerationCase in
        return enumerationCase.referenceAction.flatMap({ nativeImplementation(of: $0) }) != nil
      }) {
      return nil
    }

    let name = nativeName(of: thing, referenceLookup: externalReferenceLookup) ?? sanitize(
      identifier: thing.globallyUniqueIdentifier(referenceLookup: externalReferenceLookup),
      leading: true,
      entire: true
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
          alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements,
          coverageIndex: coverageIndex,
          anonymousCounter: &anonymousCounter
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
          leading: true,
          entire: true
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
            leading: true,
            entire: true
          )
          let type = source(for: part.contents, referenceLookup: externalReferenceLookup)
          return parameterDeclaration(label: nil, name: name, type: type, isThrough: false)
        })
      }
      let constructorAccess = accessModifier(for: specifiedConstructor?.access ?? .file, memberScope: true)
      let constructorSetters = thing.parts.map({ part in
        let name = sanitize(
          identifier: part.names.identifier(),
          leading: true,
          entire: true
        )
        return constructorSetter(name: name)
      })
      let componentHolds: [String] = thing.parts.compactMap { part in
        guard let hold = nativeHold(on: part.contents, referenceLookup: externalReferenceLookup) else {
          return nil
        }
        let partName = sanitize(
          identifier: part.names.identifier(),
          leading: true,
          entire: true
        )
        return apply(
          nativeReferenceCountingAction: hold,
          around: "target.\(partName)",
          referenceLookup: externalReferenceLookup
        )
      }
      let componentReleases: [String] = thing.parts.compactMap { part in
        guard let release = nativeRelease(of: part.contents, referenceLookup: externalReferenceLookup) else {
          return nil
        }
        let partName = sanitize(
          identifier: part.names.identifier(),
          leading: true,
          entire: true
        )
        return apply(
          nativeReferenceCountingAction: release,
          around: "target.\(partName)",
          referenceLookup: externalReferenceLookup
        )
      }
      return thingDeclaration(
        name: name,
        components: components,
        accessModifier: access,
        constructorParameters: constructorParameters,
        constructorAccessModifier: constructorAccess,
        constructorSetters: constructorSetters,
        otherMembers: members,
        isReferenceCounted: thing.requiresCleanUp == true,
        synthesizeReferenceCounting: thing.requiresCleanUp == true && thing.c?.release == nil,
        componentHolds: componentHolds,
        componentReleases: componentReleases,
        copyOld: copyOld(thing: thing, name: name, externalReferenceLookup: externalReferenceLookup),
        releaseOld: releaseOld(thing: thing, name: name, externalReferenceLookup: externalReferenceLookup)
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
      let componentHolds: [(String, String)] = thing.cases.compactMap { enumerationCase in
        guard let contents = enumerationCase.contents,
          let hold = nativeHold(on: contents, referenceLookup: externalReferenceLookup) else {
          return nil
        }
        let caseName = sanitize(
          identifier: enumerationCase.names.identifier(),
          leading: true,
          entire: true
        )
        let call = apply(
          nativeReferenceCountingAction: hold,
          around: "target.value.\(name)_case_\(caseName)",
          referenceLookup: externalReferenceLookup
        )
        return (caseName, call)
      }
      let componentReleases: [(String, String)] = thing.cases.compactMap { enumerationCase in
        guard let contents = enumerationCase.contents,
          let release = nativeRelease(of: contents, referenceLookup: externalReferenceLookup) else {
          return nil
        }
        let caseName = sanitize(
          identifier: enumerationCase.names.identifier(),
          leading: true,
          entire: true
        )
        let call = apply(
          nativeReferenceCountingAction: release,
          around: "target.value.\(name)_case_\(caseName)",
          referenceLookup: externalReferenceLookup
        )
        return (caseName, call)
      }
      let copyOld: String? = (thing.requiresCleanUp == true ? synthesizedCopy(of: name) : nil)
        .map { copy in
          apply(
            nativeReferenceCountingAction: copy,
            around: "old",
            referenceLookup: externalReferenceLookup
          )
        }
      let releaseOld: String? = (thing.requiresCleanUp == true ? synthesizedRelease(of: name) : nil)
        .map { release in
          apply(
            nativeReferenceCountingAction: release,
            around: "old",
            referenceLookup: externalReferenceLookup
          )
        }
      return enumerationTypeDeclaration(
        name: name,
        cases: cases,
        accessModifier: access,
        simple: thing.isSimple,
        storageCases: storageCases,
        otherMembers: members,
        isReferenceCounted: thing.requiresCleanUp == true,
        synthesizeReferenceCounting: thing.requiresCleanUp == true && thing.c?.release == nil,
        componentHolds: componentHolds,
        componentReleases: componentReleases,
        copyOld: copyOld,
        releaseOld: releaseOld
      )
    }
  }

  static func nativeHold(
    on thing: ParsedTypeReference,
    referenceLookup: [ReferenceDictionary]
  ) -> NativeActionExpressionIntermediate? {
    guard let type = referenceLookup.lookupThing(thing.key) else {
      return nil
    }
    if let native = nativeType(of: type) {
      return native.hold
    } else if type.requiresCleanUp == true {
      return synthesizedHold(on: source(for: thing, referenceLookup: referenceLookup))
    } else {
      return nil
    }
  }

  static func nativeRelease(
    of thing: ParsedTypeReference,
    referenceLookup: [ReferenceDictionary]
  ) -> NativeActionExpressionIntermediate? {
    guard let type = referenceLookup.lookupThing(thing.key) else {
      return nil
    }
    if let native = nativeType(of: type) {
      return native.release
    } else if type.requiresCleanUp == true {
      return synthesizedRelease(of: source(for: thing, referenceLookup: referenceLookup))
    } else {
      return nil
    }
  }

  static func nativeCopy(
    of thing: ParsedTypeReference,
    referenceLookup: [ReferenceDictionary]
  ) -> NativeActionExpressionIntermediate? {
    guard let type = referenceLookup.lookupThing(thing.key) else {
      return nil
    }
    if let native = nativeType(of: type) {
      return native.copy
    } else if type.requiresCleanUp == true {
      return synthesizedCopy(of: source(for: thing, referenceLookup: referenceLookup))
    } else {
      return nil
    }
  }

  static func nativeDetachment(
    from thing: ParsedTypeReference,
    referenceLookup: [ReferenceDictionary]
  ) -> NativeActionExpressionIntermediate? {
    guard let type = referenceLookup.lookupThing(thing.key) else {
      return nil
    }
    if type.requiresCleanUp == true {
      return synthesizedDetachment(from: source(for: thing, referenceLookup: referenceLookup))
    } else {
      return nil
    }
  }

  static func apply(
    nativeReferenceCountingAction: NativeActionExpressionIntermediate,
    around wrappedExpression: String,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    var accumulator: String = ""
    for index in nativeReferenceCountingAction.textComponents.indices {
      accumulator.append(contentsOf: String(nativeReferenceCountingAction.textComponents[index]))
      if index != nativeReferenceCountingAction.textComponents.indices.last {
        let parameter = nativeReferenceCountingAction.parameters[index]
        if let type = parameter.typeInstead {
          let typeSource = source(for: type, referenceLookup: referenceLookup)
          if parameter.sanitizedForIdentifier {
            accumulator.append(contentsOf: identifierPrefix(for: typeSource))
          } else {
            accumulator.append(contentsOf: typeSource)
          }
        } else {
          accumulator.append(wrappedExpression)
        }
      }
    }
    return accumulator
  }

  static func flowCoverageRegistration(
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    indentationLevel: Int,
    statements: Array<StatementIntermediate>.SubSequence
  ) -> String? {
    coverageRegionCounter += 1
    if let coverage = contextCoverageIdentifier,
      statements.first?.isDeadEnd != true {
      let appendedIdentifier = "\(coverage):{\(coverageRegionCounter.inDigits())}"
      let indent = String(repeating: self.indent, count: indentationLevel)
      if let index = coverageIndex[UnicodeText(appendedIdentifier)] {
        return "\n\(indent)\(self.coverageRegistration(index: index))"
      }
    }
    return nil
  }

  static func call(scalarLiteral: LiteralIntermediate, normalize: Bool) -> String {
    var contents = scalarLiteral.string
    if normalize {
      contents = contents.decomposedStringWithCompatibilityMapping
    }
    return self.literal(scalars: contents, escaped: sanitize(stringLiteral: contents))
  }

  static func call(
    literal: LiteralIntermediate,
    type: Thing,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    isNativeArgument: Bool,
    contextCoverageIdentifier: UnicodeText?,
    extractedCoverageRegistrations: inout [String],
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedArgumentsForReferenceUnpacking: inout [String],
    extractedArgumentsForReferenceCounting: inout [String],
    isArgumentExtraction: Bool,
    extractedAnonymousFunctions: inout [String],
    isDirectReturn: Bool,
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode
  ) -> String {
    if let loading = literal.loadingAction(type: type) {
      return call(
        to: loading,
        expectedPassedActionParameters: nil,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        isNativeArgument: isNativeArgument,
        contextCoverageIdentifier: contextCoverageIdentifier,
        extractedCoverageRegistrations: &extractedCoverageRegistrations,
        coverageRegionCounter: &coverageRegionCounter,
        coverageIndex: coverageIndex,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
        extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
        isThrough: false,
        isDirectReturn: isDirectReturn,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        normalizeNextNestedLiteral: type.names.contains(LiteralIntermediate.unicodeTextName),
        mode: mode
      )
    } else if type.names.contains(LiteralIntermediate.unicodeScalarName) {
      return self.literal(scalar: literal.string.unicodeScalars.first!)
    } else if type.names.contains(LiteralIntermediate.naturalNumberName)
      || type.names.contains(LiteralIntermediate.integerName)
      || type.names.contains(LiteralIntermediate.platformFixedWidthNaturalNumberName)
      || type.names.contains(LiteralIntermediate.platformFixedWidthIntegerName)
      || type.names.contains(LiteralIntermediate.eightBitNaturalNumberName)
      || type.names.contains(LiteralIntermediate.memoryOffsetName) {
      return self.literal(number: literal.string, typeNames: type.names)
    } else if type.names.contains(LiteralIntermediate.byteName) {
      return self.literal(byte: literal.string)
    } else if type.names.contains(LiteralIntermediate.unicodeScalarNumericalValueName) {
      return self.literal(unicodeScalarNumericalValue: literal.string)
    } else {
      return call(scalarLiteral: literal, normalize: normalizeNextNestedLiteral)
    }
  }

  static func modify(
    nativeParameter parameter: inout String,
    accordingTo details: NativeActionImplementationParameter,
    condition: (NativeActionImplementationParameter) -> Bool,
    argument: ActionUse,
    referenceLookup: [ReferenceDictionary],
    getImplementation: (ParsedTypeReference, [ReferenceDictionary]) -> NativeActionExpressionIntermediate?,
    delayUntilCleanUp: Bool = false,
    cleanUpCode: inout String
  ) {
    if condition(details),
      let partiallyUnwrapped = argument.resolvedResultType,
      let parameterType = partiallyUnwrapped,
      let implementation = getImplementation(parameterType, referenceLookup) {
      let wrapped = apply(nativeReferenceCountingAction: implementation, around: parameter, referenceLookup: referenceLookup)
      if delayUntilCleanUp {
        cleanUpCode.prepend(contentsOf: statement(expression: wrapped).appending(contentsOf: "\n"))
      } else {
        parameter = wrapped
      }
    }
  }

  static func resolveExpectedParameterOrder(for action: ActionIntermediate?) -> [ParameterIntermediate]? {
    return action.map { action in
      let outputName = nativeNameDeclaration(of: action) ?? action.names.identifier()
      return action.parameters.ordered(for: outputName)
    }
  }
  static func pass(
    actionLiteral: ActionLiteralIntermediate,
    reference: ActionUse,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    context: ActionIntermediate?,
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedAnonymousFunctions: inout [String],
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
    mode: CompilationMode
  ) -> String {
    guard case .action(let passedActionParameters, let passedActionReturn) = reference.resolvedResultType!! else { fatalError() }
    let parameterTypes = passedActionParameters.map({ source(for: $0, referenceLookup: referenceLookup) })
    let parameterTypesList = parameterTypes.joined(separator: ", ")
    let parameters = zip(reference.rearrangedParameters, parameterTypes)
      .map({ name, type in
        return parameterDeclaration(label: nil, name: String(name), type: type, isThrough: false)
      }).joined(separator: ", ")
    let returnType = passedActionReturn.map({ source(for: $0, referenceLookup: referenceLookup) })
    var implementation: [String] = []
    if let coverage = flowCoverageRegistration(
        contextCoverageIdentifier: contextCoverageIdentifier,
        coverageRegionCounter: &coverageRegionCounter,
        coverageIndex: coverageIndex,
        indentationLevel: 0,
        statements: actionLiteral.implementation.statements[...]
    ) {
      implementation.append(coverage)
    }
    implementation.append(
      contentsOf: source(
        for: actionLiteral.implementation.statements,
        context: context,
        localLookup: localLookup.appending(
          actionLiteral.parameterDictionary(
            rearrangedParameters: reference.rearrangedParameters,
            explicitSignature: reference.explicitResultType!,
            referenceLookup: referenceLookup
          )
        ),
        coverageRegionCounter: &coverageRegionCounter,
        coverageIndex: coverageIndex,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
        referenceLookup: referenceLookup,
        inliningArguments: inliningArguments,
        mode: mode,
        indentationLevel: 0
      )
    )
    if needsFunctionLiteralsExtracted {
      anonymousCounter += 1
      let extractedName = "anonymous_\(anonymousCounter)"
      extractedAnonymousFunctions.append(
        functionLiteral(
          assignedName: extractedName,
          parameters: parameters,
          parameterTypes: parameterTypesList,
          returnType: returnType,
          implementation: implementation
        )
      )
      return extractedName
    } else {
      return functionLiteral(
        assignedName: nil,
        parameters: parameters,
        parameterTypes: parameterTypesList,
        returnType: returnType,
        implementation: implementation
      )
    }
  }
  static func rearrangeParametersIfNecessary(
    actionTypeParameters: [ParsedTypeReference],
    actionTypeReturn: ParsedTypeReference?,
    rearrangementList: [UnicodeText],
    referenceLookup: [ReferenceDictionary],
    lookupAction: () -> ActionIntermediate?,
    lookupActionOutputName: (ActionIntermediate?) -> UnicodeText?,
    lookupCallOrder: (ActionIntermediate?, UnicodeText?) -> [UnicodeText],
    lookupCallParameterTypes: (ActionIntermediate?, UnicodeText?) -> [ParsedTypeReference],
    expectedPassedActionParameters: [ParameterIntermediate],
    anonymousCounter: inout Int,
    extractedAnonymousFunctions: inout [String],
    directPass: (inout Int, inout [String]) -> String,
    wrappedNode: (inout Int, inout [String]) -> String
  ) -> String {
    if actionTypeParameters.count <= 1 {
      return directPass(&anonymousCounter, &extractedAnonymousFunctions)
    } else {
      if !rearrangementList.isEmpty {
        let action = lookupAction()
        let actionOutputName = lookupActionOutputName(action)
        let callOrder = lookupCallOrder(action, actionOutputName)
        let reordering = expectedPassedActionParameters.map({ parameter in
          return callOrder.firstIndex(where: { parameter.names.contains($0) })!
        })
        let sorted = reordering.sorted()
        if reordering == sorted {
          return directPass(&anonymousCounter, &extractedAnonymousFunctions)
        } else {
          let fromParameterTypes = lookupCallParameterTypes(action, actionOutputName)
          let from = sorted.map({ index in
            return numberedParameter(
              position: index + 1,
              type: source(for: fromParameterTypes[index], referenceLookup: referenceLookup)
            )
          }).joined(separator: ", ")
          let to = reordering.map({ numberedParameter(position: $0 + 1, type: nil) }).joined(separator: ", ")
          let returnType = actionTypeReturn.map({ source(for: $0, referenceLookup: referenceLookup) })
          if needsFunctionLiteralsExtracted {
            anonymousCounter += 1
            let wrapperName = "anonymous_\(anonymousCounter)"
            extractedAnonymousFunctions.append(
              wrap(
                passedFunction: wrappedNode(&anonymousCounter, &extractedAnonymousFunctions),
                rearrangingParametersFrom: from,
                to: to,
                wrapperName: wrapperName,
                returnType: returnType
              )
            )
            return wrapperName
          } else {
            return wrap(
              passedFunction: wrappedNode(&anonymousCounter, &extractedAnonymousFunctions),
              rearrangingParametersFrom: from,
              to: to,
              wrapperName: nil,
              returnType: returnType
            )
          }
        }
      } else {
        fatalError("Parameter rearrangement inference based on types has not been implemented yet.")
      }
    }
  }

  static func call(
    to reference: ActionUse,
    expectedPassedActionParameters: [ParameterIntermediate]?,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    isNativeArgument: Bool,
    contextCoverageIdentifier: UnicodeText?,
    extractedCoverageRegistrations: inout [String],
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedArgumentsForReferenceUnpacking: inout [String],
    extractedArgumentsForReferenceCounting: inout [String],
    isArgumentExtraction: Bool = false,
    extractedAnonymousFunctions: inout [String],
    isThrough: Bool,
    isDetachment: Bool = false,
    isDirectReturn: Bool,
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode
  ) -> String {
    if let literal = reference.literal {
      let resolvedReference = reference.resolvedResultType!!
      if !isArgumentExtraction,
        !extractedArgumentsForReferenceCounting.isEmpty,
        nativeRelease(of: resolvedReference, referenceLookup: referenceLookup) != nil {
        return extractedArgumentsForReferenceCounting.removeFirst()
      }
      let type = referenceLookup.lookupThing(resolvedReference.key)!
      return call(
        literal: literal,
        type: type,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        isNativeArgument: isNativeArgument,
        contextCoverageIdentifier: contextCoverageIdentifier,
        extractedCoverageRegistrations: &extractedCoverageRegistrations,
        coverageRegionCounter: &coverageRegionCounter,
        coverageIndex: coverageIndex,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
        extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
        isArgumentExtraction: isArgumentExtraction,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
        isDirectReturn: isDirectReturn,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        normalizeNextNestedLiteral: normalizeNextNestedLiteral,
        mode: mode
      )
    }
    if let actionLiteral = reference.actionLiteral {
      guard case .action(let assembledActionParameters, let assembledActionReturn) = reference.resolvedResultType!! else { fatalError() }
      return rearrangeParametersIfNecessary(
        actionTypeParameters: assembledActionParameters,
        actionTypeReturn: assembledActionReturn,
        rearrangementList: reference.rearrangedParameters,
        referenceLookup: referenceLookup,
        lookupAction: { nil },
        lookupActionOutputName: { _ in nil },
        lookupCallOrder: { _, _ in reference.rearrangedParameters },
        lookupCallParameterTypes: { _, _ in assembledActionParameters },
        expectedPassedActionParameters: expectedPassedActionParameters!,
        anonymousCounter: &anonymousCounter,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
        directPass: { anonymousCounter, extractedAnonymousFunctions in
          return pass(
            actionLiteral: actionLiteral,
            reference: reference,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            context: context,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            coverageIndex: coverageIndex,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            anonymousCounter: &anonymousCounter,
            extractedAnonymousFunctions: &extractedAnonymousFunctions,
            inliningArguments: inliningArguments,
            mode: mode
          )
        },
        wrappedNode: { anonymousCounter, extractedAnonymousFunctions in
          return pass(
            actionLiteral: actionLiteral,
            reference: reference,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            context: context,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            coverageIndex: coverageIndex,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            anonymousCounter: &anonymousCounter,
            extractedAnonymousFunctions: &extractedAnonymousFunctions,
            inliningArguments: inliningArguments,
            mode: mode
          )
        }
      )
    }
    let signature = reference.arguments.map({ $0.resolvedResultType!! })
    if let inlined = inliningArguments[reference.actionName] {
      return dereference(
        throughParameter: inlined.argument,
        forwarding: !(inlined.stillNeedsDereferencingIfNativeArgument && isNativeArgument)
      )
    } else if reference.passage == .out {
      return String(sanitize(identifier: reference.actionName, leading: true, entire: true))
    } else if let local = localLookup.lookupAction(
      reference.actionName,
      signature: signature,
      specifiedReturnValue: reference.resolvedResultType,
      externalLookup: referenceLookup
    ) {
      return String(sanitize(identifier: local.names.identifier(), leading: true, entire: true))
    } else if let parameter = context?.lookupParameter(reference.actionName) {
      let parameterName = nativeName(of: parameter) ?? sanitize(identifier: parameter.names.identifier(), leading: true, entire: true)
      if parameter.passAction.returnValue?.key.resolving(fromReferenceLookup: referenceLookup)
        == reference.resolvedResultType!?.key.resolving(fromReferenceLookup: referenceLookup) {
        var returnValue: String
        if parameter.passage == .through {
          returnValue = dereference(
            throughParameter: parameterName,
            forwarding: reference.passage == .through && !isNativeArgument
          )
        } else {
          returnValue = parameterName
        }
        if isDirectReturn,
          let hold = nativeHold(on: parameter.type, referenceLookup: referenceLookup)  {
          return apply(nativeReferenceCountingAction: hold, around: returnValue, referenceLookup: referenceLookup)
        } else {
          return returnValue
        }
      } else {
        return call(
          to: parameter.executeAction!,
          bareAction: parameter.executeAction!,
          reference: reference,
          expectedPassedActionParameters: expectedPassedActionParameters,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          parameterName: parameterName,
          contextCoverageIdentifier: contextCoverageIdentifier,
          extractedCoverageRegistrations: &extractedCoverageRegistrations,
          coverageRegionCounter: &coverageRegionCounter,
          coverageIndex: coverageIndex,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          anonymousCounter: &anonymousCounter,
          extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
          extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
          extractedAnonymousFunctions: &extractedAnonymousFunctions,
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
         !isArgumentExtraction {
        if !extractedArgumentsForReferenceCounting.isEmpty,
           reference.passage != .through,
           let result = action.returnValue,
           nativeRelease(of: result, referenceLookup: referenceLookup) != nil {
          return extractedArgumentsForReferenceCounting.removeFirst()
        }
        if !extractedArgumentsForReferenceUnpacking.isEmpty,
          reference.arguments.contains(where: { $0.passage == .through }) {
          return extractedArgumentsForReferenceUnpacking.removeFirst()
        }
      }
      let basicCall: String = call(
        to: bareAction.isFlow ? bareAction : action,
        bareAction: bareAction,
        reference: reference,
        expectedPassedActionParameters: expectedPassedActionParameters,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        parameterName: nil,
        contextCoverageIdentifier: contextCoverageIdentifier,
        extractedCoverageRegistrations: &extractedCoverageRegistrations,
        coverageRegionCounter: &coverageRegionCounter,
        coverageIndex: coverageIndex,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
        extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        normalizeNextNestedLiteral: normalizeNextNestedLiteral,
        mode: mode
      )
      if mode == .testing,
        bareAction.isFlow,
        bareAction.deservesTesting,
        let coveredIdentifier = action.coveredIdentifier,
        let index = coverageIndex[coveredIdentifier] {
        extractedCoverageRegistrations.append(coverageRegistration(index: index))
      }
      if !isThrough,
        !isDetachment,
        bareAction.isAccessor,
        let returnType = bareAction.returnValue,
        let hold = nativeHold(on: returnType, referenceLookup: referenceLookup) {
        return apply(
          nativeReferenceCountingAction: hold,
          around: basicCall,
          referenceLookup: referenceLookup
        )
      } else {
        return basicCall
      }
    }
  }
  static func call(
    to action: ActionIntermediate,
    bareAction: ActionIntermediate,
    reference: ActionUse,
    expectedPassedActionParameters: [ParameterIntermediate]?,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    parameterName: String?,
    contextCoverageIdentifier: UnicodeText?,
    extractedCoverageRegistrations: inout [String],
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedArgumentsForReferenceUnpacking: inout [String],
    extractedArgumentsForReferenceCounting: inout [String],
    extractedAnonymousFunctions: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
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
      var nativeWrap: NativeActionExpressionIntermediate?
      var beforeCleanUp: String? = nil
      var local = ReferenceDictionary()
      let nativeExpression = native.expression
      for index in nativeExpression.textComponents.indices {
        accumulator.append(contentsOf: String(nativeExpression.textComponents[index]))
        if index != nativeExpression.textComponents.indices.last {
          let parameter = nativeExpression.parameters[index]
          if let type = parameter.typeInstead {
            if parameter.hold {
              nativeWrap = nativeHold(on: type, referenceLookup: referenceLookup)
            } else {
              let typeSource = source(for: type, referenceLookup: referenceLookup)
              if parameter.sanitizedForIdentifier {
                accumulator.append(contentsOf: identifierPrefix(for: typeSource))
              } else {
                accumulator.append(contentsOf: typeSource)
              }
            }
          } else if let enumerationCase = parameter.caseInstead {
            switch enumerationCase {
            case .simple, .compound, .action, .statements, .partReference:
              fatalError("Only enumeration cases should be stored in “caseInstead”.")
            case .enumerationCase(enumeration: let type, identifier: let identifier):
              let reference = caseReference(
                name: sanitize(identifier: identifier, leading: true, entire: true),
                type: source(for: type, referenceLookup: referenceLookup),
                simple: false,
                ignoringValue: true
              )
              accumulator.append(contentsOf: reference)
            }
          } else {
            let name = parameter.name
            if parameter.unique {
              accumulator.append(sanitize(identifier: name, leading: true, entire: true))
              accumulator.append(String(clashAvoidanceCounter))
              didUseClashAvoidance = true
            } else if parameter.remainderOfScope {
              beforeCleanUp = accumulator
              accumulator = ""
            } else if let argumentIndex = usedParameters.firstIndex(where: { $0.names.contains(name) }) {
              let argument = reference.arguments[argumentIndex]
              switch argument {
              case .action(let actionArgument):
                var result = call(
                  to: actionArgument,
                  expectedPassedActionParameters: resolveExpectedParameterOrder(for: usedParameters[argumentIndex].executeAction),
                  context: context,
                  localLookup: localLookup.appending(local),
                  referenceLookup: referenceLookup,
                  isNativeArgument: true,
                  contextCoverageIdentifier: contextCoverageIdentifier,
                  extractedCoverageRegistrations: &extractedCoverageRegistrations,
                  coverageRegionCounter: &coverageRegionCounter,
                  coverageIndex: coverageIndex,
                  clashAvoidanceCounter: &clashAvoidanceCounter,
                  anonymousCounter: &anonymousCounter,
                  extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
                  extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
                  extractedAnonymousFunctions: &extractedAnonymousFunctions,
                  isThrough: actionArgument.passage == .through,
                  isDirectReturn: false,
                  cleanUpCode: &cleanUpCode,
                  inliningArguments: inliningArguments,
                  normalizeNextNestedLiteral: normalizeNextNestedLiteral,
                  mode: mode
                )
                modify(
                  nativeParameter: &result,
                  accordingTo: parameter,
                  condition: { $0.hold },
                  argument: actionArgument,
                  referenceLookup: referenceLookup,
                  getImplementation: nativeHold,
                  cleanUpCode: &cleanUpCode
                )
                modify(
                  nativeParameter: &result,
                  accordingTo: parameter,
                  condition: { $0.release },
                  argument: actionArgument,
                  referenceLookup: referenceLookup,
                  getImplementation: nativeRelease,
                  cleanUpCode: &cleanUpCode
                )
                modify(
                  nativeParameter: &result,
                  accordingTo: parameter,
                  condition: { $0.copy },
                  argument: actionArgument,
                  referenceLookup: referenceLookup,
                  getImplementation: nativeCopy,
                  cleanUpCode: &cleanUpCode
                )
                modify(
                  nativeParameter: &result,
                  accordingTo: parameter,
                  condition: { $0.held },
                  argument: actionArgument,
                  referenceLookup: referenceLookup,
                  getImplementation: nativeRelease,
                  delayUntilCleanUp: true,
                  cleanUpCode: &cleanUpCode
                )
                accumulator.append(
                  contentsOf: result
                )
              case .flow(let statements):
                if mode == .testing,
                   let coverage = flowCoverageRegistration(
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter,
                    coverageIndex: coverageIndex,
                    indentationLevel: 1,
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
                    coverageIndex: coverageIndex,
                    clashAvoidanceCounter: &clashAvoidanceCounter,
                    anonymousCounter: &anonymousCounter,
                    extractedAnonymousFunctions: &extractedAnonymousFunctions,
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
              fatalError()
            }
          }
        }
      }
      if let wrap = nativeWrap {
        accumulator = apply(
          nativeReferenceCountingAction: wrap,
          around: accumulator,
          referenceLookup: referenceLookup
        )
      }
      if let before = beforeCleanUp {
        cleanUpCode.prepend(contentsOf: accumulator)
        return before
      } else {
        return accumulator
      }
    } else if action.isMemberWrapper {
      let name = parameterName ?? sanitize(identifier: action.names.identifier(), leading: true, entire: true)
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
      var newInliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)] = [:]
      var locals = ReferenceDictionary()
      for index in parameters.indices {
        let parameter = parameters[index]
        let argument = reference.arguments[index]
        switch argument {
        case .action(let action):
          newInliningArguments[parameter.names.identifier()] = (
            argument: call(
              to: action,
              expectedPassedActionParameters: resolveExpectedParameterOrder(for: parameter.executeAction),
              context: context,
              localLookup: localLookup.appending(locals),
              referenceLookup: referenceLookup,
              isNativeArgument: false,
              contextCoverageIdentifier: contextCoverageIdentifier,
              extractedCoverageRegistrations: &extractedCoverageRegistrations,
              coverageRegionCounter: &coverageRegionCounter,
              coverageIndex: coverageIndex,
              clashAvoidanceCounter: &clashAvoidanceCounter,
              anonymousCounter: &anonymousCounter,
              extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
              extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
              extractedAnonymousFunctions: &extractedAnonymousFunctions,
              isThrough: action.passage == .through,
              isDirectReturn: false,
              cleanUpCode: &cleanUpCode,
              inliningArguments: inliningArguments,
              normalizeNextNestedLiteral: normalizeNextNestedLiteral,
              mode: mode
            ),
            stillNeedsDereferencingIfNativeArgument: parameter.passage == .through
              && action.passage == .through
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
            coverageIndex: coverageIndex,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            anonymousCounter: &anonymousCounter,
            extractedAnonymousFunctions: &extractedAnonymousFunctions,
            referenceLookup: referenceLookup,
            inliningArguments: inliningArguments,
            mode: mode,
            indentationLevel: 0
          )
          if mode == .testing,
            let coverage = flowCoverageRegistration(
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            coverageIndex: coverageIndex,
            indentationLevel: 0,
            statements: flow.statements[...]
          ) {
            source.prepend(coverage)
          }
          newInliningArguments[parameter.names.identifier()] = (
            argument: source.joined(separator: "\n"),
            stillNeedsDereferencingIfNativeArgument: false
          )
        }
      }
      var newCoverageRegionCounter = 0
      return source(
        for: action.implementation!.statements,
        context: action,
        localLookup: localLookup,
        coverageRegionCounter: &newCoverageRegionCounter,
        coverageIndex: coverageIndex,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
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
          leading: true,
          entire: true
        )
      if action.isReferenceWrapper {
        guard case .action(let returnedActionParameters, let returnedActionReturn) = bareAction.returnValue! else { fatalError() }
        return rearrangeParametersIfNecessary(
          actionTypeParameters: returnedActionParameters,
          actionTypeReturn: returnedActionReturn,
          rearrangementList: reference.rearrangedParameters,
          referenceLookup: referenceLookup,
          lookupAction: {
            let bareIdentifier = bareAction.names.identifier()
            return referenceLookup.lookupAction(bareIdentifier, signature: returnedActionParameters, specifiedReturnValue: returnedActionReturn)!
          },
          lookupActionOutputName: { referencedAction in
            return nativeNameDeclaration(of: action) ?? bareAction.names.identifier()
          },
          lookupCallOrder: { referencedAction, outputName in
            return order(
              reference.rearrangedParameters,
              for: referencedAction!.parameters.reordering(from: reference.actionName, to: outputName!)
            )
          },
          lookupCallParameterTypes: { referencedAction, outputName in
            return referencedAction!.parameters.ordered(for: outputName!).map({ $0.type })
          },
          expectedPassedActionParameters: expectedPassedActionParameters!,
          anonymousCounter: &anonymousCounter,
          extractedAnonymousFunctions: &extractedAnonymousFunctions,
          directPass: { _, _ in
            let prefix = actionReferencePrefix(isVariable: parameterName != nil) ?? ""
            return "\(prefix)\(name)"
          },
          wrappedNode: { _, _ in name }
        )
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
              let nestedCall = call(
                to: actionArgument,
                expectedPassedActionParameters: resolveExpectedParameterOrder(for: parameter.executeAction),
                context: context,
                localLookup: localLookup,
                referenceLookup: referenceLookup,
                isNativeArgument: false,
                contextCoverageIdentifier: contextCoverageIdentifier,
                extractedCoverageRegistrations: &extractedCoverageRegistrations,
                coverageRegionCounter: &coverageRegionCounter,
                coverageIndex: coverageIndex,
                clashAvoidanceCounter: &clashAvoidanceCounter,
                anonymousCounter: &anonymousCounter,
                extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
                extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
                extractedAnonymousFunctions: &extractedAnonymousFunctions,
                isThrough: actionArgument.passage == .through,
                isDirectReturn: false,
                cleanUpCode: &cleanUpCode,
                inliningArguments: inliningArguments,
                normalizeNextNestedLiteral: normalizeNextNestedLiteral,
                mode: mode
              )
              var reference = passReference(
                to: nestedCall,
                forwarding: context?.parameters.parameter(named: actionArgument.actionName)?.passage == .through,
                isAddressee: nativeIsMember(action: action) && argumentsArray.isEmpty
              )
              if !nestedCall.unicodeScalars.allSatisfy({ allowedIdentifierContinuationCharacters.contains($0) }),
                let referenceType = actionArgument.resolvedResultType?.flatMap({ $0 }),
                let detachmentAction = nativeDetachment(from: referenceType, referenceLookup: referenceLookup) {
                reference = apply(nativeReferenceCountingAction: detachmentAction, around: reference, referenceLookup: referenceLookup)
              }
              argumentsArray.append(
                parameterLabel + reference
              )
            } else {
              let basicCall = call(
                to: actionArgument,
                expectedPassedActionParameters: resolveExpectedParameterOrder(for: parameter.executeAction),
                context: context,
                localLookup: localLookup,
                referenceLookup: referenceLookup,
                isNativeArgument: false,
                contextCoverageIdentifier: contextCoverageIdentifier,
                extractedCoverageRegistrations: &extractedCoverageRegistrations,
                coverageRegionCounter: &coverageRegionCounter,
                coverageIndex: coverageIndex,
                clashAvoidanceCounter: &clashAvoidanceCounter,
                anonymousCounter: &anonymousCounter,
                extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
                extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
                extractedAnonymousFunctions: &extractedAnonymousFunctions,
                isThrough: actionArgument.passage == .through,
                isDirectReturn: false,
                cleanUpCode: &cleanUpCode,
                inliningArguments: inliningArguments,
                normalizeNextNestedLiteral: normalizeNextNestedLiteral,
                mode: mode
              )
              let wrappedCall: String
              if action.isCreation,
                let partiallyUnwrapped = actionArgument.resolvedResultType,
                let memberType: ParsedTypeReference = partiallyUnwrapped,
                let hold = nativeHold(on: memberType, referenceLookup: referenceLookup) {
                wrappedCall = apply(
                  nativeReferenceCountingAction: hold,
                  around: basicCall,
                  referenceLookup: referenceLookup
                )
              } else {
                wrappedCall = basicCall
              }
              argumentsArray.append(
                parameterLabel + wrappedCall
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
          if sanitize(identifier: UnicodeText(nameStart), leading: false, entire: false) != nameStart {
            return "\(argumentsArray.joined(separator: " \(name) "))"
          } else {
            var result: String = ""
            var modifiedName = name
            if nativeIsInitializer(action: action) {
              modifiedName = source(for: action.returnValue!, referenceLookup: referenceLookup)
            } else if nativeIsStaticMember(action: action) {
              modifiedName.unicodeScalars.removeFirst(staticMemberPrefix!.count - 1)
            } else if nativeIsMember(action: action) {
              let first = argumentsArray.removeFirst()
              result.append(contentsOf: first)
              if name != "subscript" {
                result.append(contentsOf: ".")
              }
            }
            if nativeIsProperty(action: action) {
              result.append(contentsOf: modifiedName)
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

  static func argumentsNeedingExtractionForImmediateReferenceUnpacking(
    from action: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    extractedCoverageRegistrations: inout [String],
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedArgumentsForReferenceCounting: inout [String],
    extractedAnonymousFunctions: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode
  ) -> ReferencePassingExtractions {
    var entries = ReferencePassingExtractions()

    if action.arguments.allSatisfy({ argument in
      if case .flow = argument {
        return false
      } else {
        return true
      }
    }) {
      return entries
    }

    extractArgumentsForImmediateReferenceUnpacking(
      from: action,
      context: context,
      localLookup: localLookup,
      referenceLookup: referenceLookup,
      contextCoverageIdentifier: contextCoverageIdentifier,
      extractedCoverageRegistrations: &extractedCoverageRegistrations,
      coverageRegionCounter: &coverageRegionCounter,
      coverageIndex: coverageIndex,
      clashAvoidanceCounter: &clashAvoidanceCounter,
      anonymousCounter: &anonymousCounter,
      extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
      extractedAnonymousFunctions: &extractedAnonymousFunctions,
      cleanUpCode: &cleanUpCode,
      inliningArguments: inliningArguments,
      normalizeNextNestedLiteral: normalizeNextNestedLiteral,
      mode: mode,
      entries: &entries
    )
    return entries
  }
  static func extractArgumentsForImmediateReferenceUnpacking(
    from action: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    extractedCoverageRegistrations: inout [String],
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedArgumentsForReferenceCounting: inout [String],
    extractedAnonymousFunctions: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode,
    entries: inout ReferencePassingExtractions
  ) {
    for argument in action.arguments {
      var entriesInThisBranch = ReferencePassingExtractions()
      defer {
        entries.append(contentsOf: entriesInThisBranch)
      }
      switch argument {
      case .action(let action):
        extractArgumentsForImmediateReferenceUnpacking(
          from: action,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          contextCoverageIdentifier: contextCoverageIdentifier,
          extractedCoverageRegistrations: &extractedCoverageRegistrations,
          coverageRegionCounter: &coverageRegionCounter,
          coverageIndex: coverageIndex,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          anonymousCounter: &anonymousCounter,
          extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
          extractedAnonymousFunctions: &extractedAnonymousFunctions,
          cleanUpCode: &cleanUpCode,
          inliningArguments: inliningArguments,
          normalizeNextNestedLiteral: normalizeNextNestedLiteral,
          mode: mode,
          entries: &entriesInThisBranch
        )

        if action.arguments.contains(where: { $0.passage == .through }),
          let result = argument.resolvedResultType,
          let actualResult = result {
          clashAvoidanceCounter += 1
          let localName = "local\(clashAvoidanceCounter)"
          let typeName = source(for: actualResult, referenceLookup: referenceLookup)
          let call = self.call(
            to: action,
            expectedPassedActionParameters: nil,
            context: context,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            isNativeArgument: false,
            contextCoverageIdentifier: contextCoverageIdentifier,
            extractedCoverageRegistrations: &extractedCoverageRegistrations,
            coverageRegionCounter: &coverageRegionCounter,
            coverageIndex: coverageIndex,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            anonymousCounter: &anonymousCounter,
            extractedArgumentsForReferenceUnpacking: &entriesInThisBranch.unused,
            extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
            isArgumentExtraction: true,
            extractedAnonymousFunctions: &extractedAnonymousFunctions,
            isThrough: action.passage == .through,
            isDirectReturn: false,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: normalizeNextNestedLiteral,
            mode: mode
          )
          entriesInThisBranch.append(
            ReferencePassingExtraction(
              localStorageDeclaration: localStorage(named: localName, ofType: typeName, containing: call),
              localName: localName
            )
          )
        }
      case .flow:
        break
      }
    }
  }

  static func argumentsExtractedForReferenceCounting(
    from action: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    extractedCoverageRegistrations: inout [String],
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedArgumentsForReferenceUnpacking: inout [String],
    extractedAnonymousFunctions: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
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
      extractedCoverageRegistrations: &extractedCoverageRegistrations,
      coverageRegionCounter: &coverageRegionCounter,
      coverageIndex: coverageIndex,
      clashAvoidanceCounter: &clashAvoidanceCounter,
      anonymousCounter: &anonymousCounter,
      extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
      extractedAnonymousFunctions: &extractedAnonymousFunctions,
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
    extractedCoverageRegistrations: inout [String],
    coverageRegionCounter: inout Int,
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedArgumentsForReferenceUnpacking: inout [String],
    extractedAnonymousFunctions: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
    normalizeNextNestedLiteral: Bool,
    mode: CompilationMode,
    entries: inout ReferenceCountedReturns
  ) {
    for argument in action.arguments {
      var entriesInThisBranch = ReferenceCountedReturns()
      defer {
        entries.append(contentsOf: entriesInThisBranch)
      }
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
            extractedCoverageRegistrations: &extractedCoverageRegistrations,
            coverageRegionCounter: &coverageRegionCounter,
            coverageIndex: coverageIndex,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            anonymousCounter: &anonymousCounter,
            extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
            extractedAnonymousFunctions: &extractedAnonymousFunctions,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: normalizeNextNestedLiteral,
            mode: mode,
            entries: &entriesInThisBranch
          )
        }

        if let result = argument.resolvedResultType,
          let actualResult = result,
          let release = nativeRelease(of: actualResult, referenceLookup: referenceLookup) {
          clashAvoidanceCounter += 1
          let localName = "local\(clashAvoidanceCounter)"
          let typeName = source(for: actualResult, referenceLookup: referenceLookup)
          let call = self.call(
            to: action,
            expectedPassedActionParameters: nil,
            context: context,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            isNativeArgument: false,
            contextCoverageIdentifier: contextCoverageIdentifier,
            extractedCoverageRegistrations: &extractedCoverageRegistrations,
            coverageRegionCounter: &coverageRegionCounter,
            coverageIndex: coverageIndex,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            anonymousCounter: &anonymousCounter,
            extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
            extractedArgumentsForReferenceCounting: &entriesInThisBranch.unused,
            isArgumentExtraction: true,
            extractedAnonymousFunctions: &extractedAnonymousFunctions,
            isThrough: action.passage == .through,
            isDirectReturn: false,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: normalizeNextNestedLiteral,
            mode: mode
          )
          let releaseExpression = apply(
            nativeReferenceCountingAction: release,
            around: localName,
            referenceLookup: referenceLookup
          )
          entriesInThisBranch.append(
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
    coverageIndex: [UnicodeText: Int],
    followingStatements: Array<StatementIntermediate>.SubSequence,
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedAnonymousFunctions: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
    existingReferences: inout Set<String>,
    mode: CompilationMode,
    indentationLevel: Int
  ) -> [String] {
    var entry = ""
    if let action = statement.action {
      var referenceList: [String] = []
      var extractedCoverageRegistrations: [String] = []
      var extractedForReferenceUnpacking = ReferencePassingExtractions()
      if needsReferencePreparation {
        var extractedArgumentsForReferenceCounting: [String] = []
        extractedForReferenceUnpacking = argumentsNeedingExtractionForImmediateReferenceUnpacking(
          from: action,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          contextCoverageIdentifier: contextCoverageIdentifier,
          extractedCoverageRegistrations: &extractedCoverageRegistrations,
          coverageRegionCounter: &coverageRegionCounter,
          coverageIndex: coverageIndex,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          anonymousCounter: &anonymousCounter,
          extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
          extractedAnonymousFunctions: &extractedAnonymousFunctions,
          cleanUpCode: &cleanUpCode,
          inliningArguments: inliningArguments,
          normalizeNextNestedLiteral: false,
          mode: mode
        )
        referenceList = statement.passedReferences(platform: self, referenceLookup: referenceLookup)
          .filter({ reference in
            return context?.parameters.parameter(named: reference.actionName)?.passage != .through
          })
          .map({ reference in
            var extractedArgumentsForReferenceUnpacking: [String] = []
            var extractedArgumentsForReferenceCounting: [String] = []
            return self.call(
              to: reference,
              expectedPassedActionParameters: nil,
              context: context,
              localLookup: localLookup,
              referenceLookup: referenceLookup,
              isNativeArgument: false,
              contextCoverageIdentifier: contextCoverageIdentifier,
              extractedCoverageRegistrations: &extractedCoverageRegistrations,
              coverageRegionCounter: &coverageRegionCounter,
              coverageIndex: coverageIndex,
              clashAvoidanceCounter: &clashAvoidanceCounter,
              anonymousCounter: &anonymousCounter,
              extractedArgumentsForReferenceUnpacking: &extractedArgumentsForReferenceUnpacking,
              extractedArgumentsForReferenceCounting: &extractedArgumentsForReferenceCounting,
              extractedAnonymousFunctions: &extractedAnonymousFunctions,
              isThrough: false,
              isDetachment: true,
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
            entry.append(preparation.appending("\n"))
          }
        }
        if !extractedForReferenceUnpacking.all.isEmpty {
          for argument in extractedForReferenceUnpacking.all {
            entry.append(argument.localStorageDeclaration.appending("\n"))
          }
          for reference in referenceList.reversed() {
            if let unpack = unpackReference(to: reference) {
              entry.append(unpack.appending("\n"))
            }
          }
          referenceList = []
        }
      }
      var remainingExtractedArgumentsForReferenceUnpacking = extractedForReferenceUnpacking.unused
      let extractedForReferenceCounting = argumentsExtractedForReferenceCounting(
        from: action,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        contextCoverageIdentifier: contextCoverageIdentifier,
        extractedCoverageRegistrations: &extractedCoverageRegistrations,
        coverageRegionCounter: &coverageRegionCounter,
        coverageIndex: coverageIndex,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedArgumentsForReferenceUnpacking: &remainingExtractedArgumentsForReferenceUnpacking,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
        cleanUpCode: &cleanUpCode,
        inliningArguments: inliningArguments,
        normalizeNextNestedLiteral: false,
        mode: mode
      )
      if !extractedForReferenceCounting.all.isEmpty {
        for argument in extractedForReferenceCounting.all {
          entry.append(argument.localStorageDeclaration.appending("\n"))
          cleanUpCode.prepend(contentsOf: argument.releaseStatement.appending("\n"))
        }
      }
      var closingParenthesis = ""
      if statement.isReturn {
        if referenceList.isEmpty, cleanUpCode.isEmpty {
          entry.append(contentsOf: "return ")
        } else {
          let storageType = action.resolvedResultType!
          entry.append(
            contentsOf: returnDelayStorage(
              type: storageType
                .map({ source(for: $0, referenceLookup: referenceLookup) })
            )
          )
          if let expectedType = storageType,
            let hold = nativeHold(on: expectedType, referenceLookup: referenceLookup) {
            let call = apply(
              nativeReferenceCountingAction: hold,
              around: "",
              referenceLookup: referenceLookup
            )
            entry.append(contentsOf: call.dropLast())
            closingParenthesis = String(call.last!)
          }
        }
      }
      let before = coverageRegionCounter
      var remainingExtractedArgumentsForReferenceCounting = extractedForReferenceCounting.unused
      entry.append(
        contentsOf: self.statement(
          expression: call(
            to: action,
            expectedPassedActionParameters: nil,
            context: context,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            isNativeArgument: false,
            contextCoverageIdentifier: contextCoverageIdentifier,
            extractedCoverageRegistrations: &extractedCoverageRegistrations,
            coverageRegionCounter: &coverageRegionCounter,
            coverageIndex: coverageIndex,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            anonymousCounter: &anonymousCounter,
            extractedArgumentsForReferenceUnpacking: &remainingExtractedArgumentsForReferenceUnpacking,
            extractedArgumentsForReferenceCounting: &remainingExtractedArgumentsForReferenceCounting,
            extractedAnonymousFunctions: &extractedAnonymousFunctions,
            isThrough: false,
            isDirectReturn: statement.isReturn,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            normalizeNextNestedLiteral: false,
            mode: mode
          ).appending(contentsOf: closingParenthesis)
        )
      )
      if !extractedCoverageRegistrations.isEmpty {
        entry = extractedCoverageRegistrations.joined(separator: "\n").appending("\n") + entry
      }
      if mode == .testing,
         coverageRegionCounter != before,
         let coverage = flowCoverageRegistration(
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter,
          coverageIndex: coverageIndex,
          indentationLevel: 0,
          statements: followingStatements
         ) {
        entry.append(coverage)
      }
      for reference in referenceList.reversed() {
        if let unpack = unpackReference(to: reference) {
          entry.append(unpack.prepending("\n"))
        }
      }
      if !referenceList.isEmpty || !cleanUpCode.isEmpty {
        if statement.isReturn {
          entry.append(contentsOf: "\n" + cleanUpCode)
          entry.append(contentsOf: delayedReturn)
        }
        for reference in referenceList {
          existingReferences.insert(reference)
        }
      }
    } else if statement.isReturn {
      if !cleanUpCode.isEmpty {
        entry.append(contentsOf: "\n" + cleanUpCode)
      }
      entry.append(contentsOf: self.statement(expression: "return"))
    } else {
      entry.append(contentsOf: deadEnd())
    }
    let presentIndent = String(repeating: indent, count: indentationLevel)
    entry.scalars.replaceMatches(for: "\n".scalars.literal(), with: "\n\(presentIndent)".scalars)
    return entry.prepending(contentsOf: presentIndent).components(separatedBy: "\n")
  }

  static func name(of parameter: ParameterIntermediate) -> String {
    return nativeName(of: parameter)
      ?? sanitize(identifier: parameter.names.identifier(), leading: true, entire: true)
  }
  static func source(
    for parameter: ParameterIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    let name = self.name(of: parameter)
    if !isTyped {
      return name
    } else {
      switch parameter.type {
      case .simple, .compound:
        let label = nativeLabel(of: parameter, isCreation: false)
        let typeSource = source(for: parameter.type, referenceLookup: referenceLookup)
        return parameterDeclaration(label: label, name: name, type: typeSource, isThrough: parameter.passage == .through)
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
    guard action.implementation != nil else {
      // creation
      return nil
    }

    let name = nativeName(of: action, referenceLookup: referenceLookup)
      ?? sanitize(
        identifier: action.globallyUniqueIdentifier(referenceLookup: referenceLookup),
        leading: true,
        entire: true
      )
    let parameters = action.parameters.ordered(
      for: nativeNameDeclaration(of: action) ?? action.names.identifier()
    )
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
    coverageIndex: [UnicodeText: Int],
    clashAvoidanceCounter: inout Int,
    anonymousCounter: inout Int,
    extractedAnonymousFunctions: inout [String],
    referenceLookup: [ReferenceDictionary],
    inliningArguments: [UnicodeText: (argument: String, stillNeedsDereferencingIfNativeArgument: Bool)],
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
        coverageIndex: coverageIndex,
        followingStatements: statements[entryIndex...].dropFirst(),
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
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
    if !(statements.last?.isReturn ?? false) {
      if inOrder.isEmpty {
        inOrder.append(cleanUpCode)
      } else {
        if !cleanUpCode.isEmpty {
          inOrder[inOrder.indices.last!].append(contentsOf: "\n" + cleanUpCode)
        }
      }
    }
    return inOrder.filter({ !$0.allSatisfy({ $0 == " " }) })
  }

  static func declaration(
    for action: ActionIntermediate,
    externalReferenceLookup: [ReferenceDictionary],
    mode: CompilationMode,
    isAbsorbedMember: Bool,
    hasBeenRelocated: Bool,
    alreadyHandledNativeRequirements: inout Set<String>,
    coverageIndex: [UnicodeText: Int],
    anonymousCounter: inout Int
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

    var name = nativeName(of: action, referenceLookup: externalReferenceLookup)
    ?? sanitize(
      identifier: action.globallyUniqueIdentifier(referenceLookup: externalReferenceLookup),
      leading: true,
      entire: true
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
      isMutating = first.passage == .through
      parentType = source(for: first.type, referenceLookup: externalReferenceLookup)
    }
    let parameters: String = parameterEntries
      .lazy.map({ source(for: $0, referenceLookup: externalReferenceLookup) })
      .joined(separator: ", ")
    let parameterNames = parameterEntries
      .lazy.map({ self.name(of: $0) })
      .joined(separator: ", ")

    let returnValue: String?
    if let specified = action.returnValue {
      let resultType = source(for: specified, referenceLookup: externalReferenceLookup)
      if isInitializer {
        parentType = resultType
        returnValue = nil
      } else {
        returnValue = resultType
      }
    } else {
      returnValue = emptyReturnType
    }
    var isStatic = false
    if nativeIsStaticMember(action: action) {
      name.unicodeScalars.removeFirst(staticMemberPrefix!.count)
      parentType = returnValue
      isStatic = true
    }

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0, isProperty: isProperty) })

    let access = accessModifier(for: action.access, memberScope: false)

    let coverageRegistration: String?
    if mode == .testing,
      let identifier = action.coveredIdentifier,
      let index = coverageIndex[identifier] {
      coverageRegistration = "\(indent)\(self.coverageRegistration(index: index))"
    } else {
      coverageRegistration = nil
    }
    var coverageRegionCounter = 0
    var clashAvoidanceCounter = 0
    var extractedAnonymousFunctions: [String] = []
    let implementation = splitFunctionImplementationIfTooLong(
      implementation: source(
        for: actionImplementation.statements,
        context: action,
        localLookup: [],
        coverageRegionCounter: &coverageRegionCounter,
        coverageIndex: coverageIndex,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        anonymousCounter: &anonymousCounter,
        extractedAnonymousFunctions: &extractedAnonymousFunctions,
        referenceLookup: externalReferenceLookup.appending(
          action.parameterReferenceDictionary(externalLookup: externalReferenceLookup)
        ),
        inliningArguments: [:],
        mode: mode,
        indentationLevel: 0
      ),
      indent: self.indent,
      subcall: { disambiguator, extraParameters in
        let extra = extraParameters.map({ ", \($0)" }) ?? ""
        return "\(name)\(disambiguator)(\(parameterNames)\(extra))"
      },
      subdeclaration: { disambiguator, extraParameters in
        let access = self.accessModifier(for: .unit, memberScope: parentType != nil).map({ "\($0) " }) ?? ""
        let extra = extraParameters.map({ ", \($0)" }) ?? ""
        let returnValue = returnSection ?? ""
        return "\(access)\(actionContinuationKeyword!) \(name)\(disambiguator)(\(parameters)\(extra))\(returnValue)"
      }
    )
    return actionDeclaration(
      name: name,
      parameters: parameters,
      returnSection: returnSection,
      accessModifier: access,
      coverageRegistration: coverageRegistration,
      implementation: implementation,
      parentType: parentType,
      isStatic: isStatic,
      isMutating: isMutating,
      isAbsorbedMember: isAbsorbedMember,
      isOverride: isOverride,
      propertyInstead: isProperty,
      initializerInstead: isInitializer,
      extractedDeclarations: extractedAnonymousFunctions
    )
  }
  static var actualFunctionImplementationSizeLimit: Int? {
    var result = Int.max
    if let file = fileSizeLimit {
      result = min(result, file / 2)
    }
    if let implementation = functionImplementationSizeLimit {
      result = min(result, implementation)
    }
    return result == Int.max ? nil : result
  }
  static func splitFunctionImplementationIfTooLong(
    implementation: [String],
    indent: String,
    subcall: (String, String?) -> String,
    subdeclaration: (String, String?) -> String
  ) -> [String] {
    guard let maximumGroupLength = actualFunctionImplementationSizeLimit else {
      return implementation.map { "\(indent)\($0)" }
    }
    let indentLength = indent.utf8.count
    let subcallLength = 1 + indentLength + subcall("0", nil).utf8.count + 1

    var groups: [[String]] = []
    var remainder = implementation[...]
    var accumulatedBytes = 0
    while !remainder.isEmpty {
      var next: [String] = [remainder.removeFirst()]
      while remainder.first?.first == " " || remainder.first?.first == "}" {
        next.append(remainder.removeFirst())
      }
      let nextLength = next.reduce(0, { $0 + 1 + indentLength + $1.count })
      if !groups.isEmpty,
        accumulatedBytes + nextLength + subcallLength < maximumGroupLength {
        groups[groups.indices.last!].append(contentsOf: next)
        accumulatedBytes += nextLength
      } else {
        groups.append(next)
        accumulatedBytes = nextLength
      }
    }

    if groups.isEmpty {
      return []
    }
    var locals: [String] = []
    var result = groups.removeFirst().map { line in
      if let keyword = localConstantKeyword {
        if line.hasPrefix("\(keyword) ") {
          locals.append(line)
        }
      }
      return "\(indent)\(line)"
    }
    for (index, group) in groups.enumerated() {
      var toPass: [String] = []
      var toReceive: [String] = []
      for local in locals {
        var disecting = String(local.dropFirst(4))
        disecting = disecting.components(separatedBy: " = ").first ?? disecting
        toReceive.append(parameter(toContinueLocal: disecting))
        toPass.append(disecting.components(separatedBy: ": ").first ?? disecting)
      }
      let passing = toPass.isEmpty ? nil : toPass.joined(separator: ", ")
      let receiving = toReceive.isEmpty ? nil : toReceive.joined(separator: ", ")
      result.append(contentsOf: [
        "\(indent)return \(subcall(String(index), passing))",
        "}",
        "",
        "\(subdeclaration(String(index), receiving)) {",
      ])
      for line in group {
        result.append(contentsOf: [
          "\(indent)\(line)",
        ])
      }
    }
    return result
  }

  static func sayingIdentifier(for test: TestIntermediate) -> String {
    return test.location.lazy
      .map({ String($0.identifier()) })
      .joined(separator: ":")
  }
  static func identifier(for test: TestIntermediate, leading: Bool, entire: Bool) -> String {
    return test.location.lazy.enumerated()
      .map({ sanitize(identifier: $1.identifier(), leading: leading && $0 == 0, entire: entire && test.location.count == 1) })
      .joined(separator: "_")
  }

  static func source(
    of test: TestIntermediate,
    coverageIndex: [UnicodeText: Int],
    anonymousCounter: inout Int,
    referenceLookup: [ReferenceDictionary],
    identifierIndex: inout [String: [String: Int]]
  ) -> String {
    var coverageRegionCounter = 0
    var clashAvoidanceCounter = 0
    var extractedAnonymousFunctions: [String] = []
    let implementation = source(
      for: test.statements.statements,
      context: nil,
      localLookup: [],
      coverageRegionCounter: &coverageRegionCounter,
      coverageIndex: coverageIndex,
      clashAvoidanceCounter: &clashAvoidanceCounter,
      anonymousCounter: &anonymousCounter,
      extractedAnonymousFunctions: &extractedAnonymousFunctions,
      referenceLookup: referenceLookup,
      inliningArguments: [:],
      mode: .testing,
      indentationLevel: 0
    )
    return actionDeclaration(
      name: capLengthOf(identifier: "run_\(identifier(for: test, leading: false, entire: false))", index: &identifierIndex),
      parameters: "",
      returnSection: emptyReturnType.flatMap({ self.returnSection(with: $0, isProperty: false) }),
      accessModifier: nil,
      coverageRegistration: nil,
      implementation: implementation,
      parentType: nil,
      isStatic: false,
      isMutating: false,
      isAbsorbedMember: false,
      isOverride: false,
      propertyInstead: false,
      initializerInstead: false,
      extractedDeclarations: extractedAnonymousFunctions
    ).full
  }

  static func call(test: TestIntermediate, identifierIndex: inout [String: [String: Int]]) -> [String] {
    let name = capLengthOf(identifier: "run_\(identifier(for: test, leading: false, entire: false))", index: &identifierIndex)
    return [
      register(test: "\(sayingIdentifier(for: test)) (\(name))"),
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
        var type = source(for: parameter.resolvedType!, referenceLookup: referenceLookup)
        if parameter.sanitizedForIdentifier {
          type = identifierPrefix(for: type)
        }
        line.append(contentsOf: type)
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
    alreadyHandledDeclarations: inout Set<String>,
    alreadyHandledNativeRequirements: inout Set<String>,
    coverageIndex: [UnicodeText: Int],
    anonymousCounter: inout Int,
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
        coverageIndex: coverageIndex,
        anonymousCounter: &anonymousCounter,
        modulesToSearchForMembers: modulesToSearchForMembers
      ) {
        if alreadyHandledDeclarations.insert(declaration).inserted {
          result.appendSeparatorLine()
          result.append(declaration)
        }
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
    coverageIndex: [UnicodeText: Int],
    anonymousCounter: inout Int,
    identifierIndex: inout [String: [String: Int]]
  ) -> String {
    var result: [String] = []
    let moduleReferenceLookup = module.referenceDictionary
    let referenceLookup = moduleWideImports.appending(moduleReferenceLookup)
    let allActions = moduleReferenceLookup.allActions(sorted: true)
    if needsForwardDeclarations {
      for action in allActions where !action.isFlow {
        if let declaration = forwardDeclaration(for: action, referenceLookup: referenceLookup) {
          result.appendSeparatorLine()
          result.append(declaration)
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
        alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements,
        coverageIndex: coverageIndex,
        anonymousCounter: &anonymousCounter
      ) {
        if alreadyHandledActionDeclarations.insert(declaration.uniquenessDefinition).inserted {
          result.appendSeparatorLine()
          result.append(declaration.full)
        }
      }
    }
    if mode == .testing {
      let allTests = module.allTests(sorted: true)
      for test in allTests {
        result.appendSeparatorLine()
        result.append(
          source(
            of: test,
            coverageIndex: coverageIndex,
            anonymousCounter: &anonymousCounter,
            referenceLookup: referenceLookup,
            identifierIndex: &identifierIndex
          )
        )
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
    var alreadyHandledDeclarations: Set<String> = []
    var alreadyHandledNativeRequirements: Set<String> = preexistingNativeRequirements
    var anonymousCounter: Int = 0

    var result: [String] = []

    if let settings = fileSettings {
      result.appendSeparatorLine()
      result.append(settings)
    }

    var imports: Set<String> = []
    for module in modules {
      imports.formUnion(nativeImports(for: module.referenceDictionary))
    }
    imports.formUnion(importsNeededByDeadEnd)
    imports.formUnion(importsNeededByTestScaffolding)
    if !imports.isEmpty {
      result.appendSeparatorLine()
      for importTarget in imports.sorted() {
        result.append(statementImporting(importTarget))
      }
    }

    var coverageIndex: [UnicodeText: Int] = [:]
    if mode == .testing {
      result.appendSeparatorLine()
      result.append(currentTestVariable)
      result.appendSeparatorLine()
      var regionSet: Set<UnicodeText> = []
      for module in modules {
        regionSet.formUnion(self.coverageRegions(for: module, moduleWideImports: moduleWideImportDictionary))
      }
      let regions = regionSet
        .sorted(by: { $0.lexicographicallyPrecedes($1) })
      for (index, region) in regions.enumerated() {
        coverageIndex[region] = index
      }
      result.append(contentsOf: coverageRegionIndex(regions: regions.map({ sanitize(stringLiteral: $0) })))
      result.append(contentsOf: registerCoverageAction)
    }

    var relocatedActions: Set<String> = []
    for module in modules {
      result.appendSeparatorLine()
      result.append(
        typesSource(
          for: module,
          moduleWideImports: moduleWideImportDictionary,
          mode: mode,
          relocatedActions: &relocatedActions,
          alreadyHandledDeclarations: &alreadyHandledDeclarations,
          alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements,
          coverageIndex: coverageIndex,
          anonymousCounter: &anonymousCounter,
          modulesToSearchForMembers: modules
        )
      )
    }

    if let start = actionDeclarationsContainerStart {
      result.appendSeparatorLine()
      result.append(contentsOf: start)
    }
    var alreadyHandledActionDeclarations: Set<String> = []
    var identifierIndex: [String: [String: Int]] = [:]
    for module in modules {
      result.appendSeparatorLine()
      result.append(
        self.actionsSource(
          for: module,
          mode: mode,
          moduleWideImports: moduleWideImportDictionary,
          relocatedActions: relocatedActions,
          alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements,
          alreadyHandledActionDeclarations: &alreadyHandledActionDeclarations,
          coverageIndex: coverageIndex,
          anonymousCounter: &anonymousCounter,
          identifierIndex: &identifierIndex
        )
      )
    }
    if mode == .testing {
      var allTests: [TestIntermediate] = []
      for module in modules {
        allTests.append(contentsOf: module.allTests(sorted: true))
      }
      result.appendSeparatorLine()
      let testCalls = splitFunctionImplementationIfTooLong(
        implementation: allTests.flatMap({ call(test: $0, identifierIndex: &identifierIndex) }),
        indent: self.indent,
        subcall: { "test\($0)(\($1 ?? ""))" },
        subdeclaration: { "\(actionContinuationKeyword!) test\($0)(\($1 ?? ""))" }
      )
      result.append(contentsOf: testSummary(testCalls: testCalls))
    }
    if let end = actionDeclarationsContainerEnd {
      result.append(contentsOf: end)
    }

    return result.joined(separator: "\n").appending("\n")
  }

  static func splitLongFile(_ file: String) -> [String] {
    var lines = (file.components(separatedBy: "\n") as [String])[...]
    let importLines = Array(lines.prefix(while: { $0.hasPrefix("import") }))
    lines.removeFirst(importLines.count)
    let imports = importLines.joined(separator: "\n")
    let importsLength = imports.utf8.count

    var files: [String] = []
    var accumulatedBytes = importsLength
    while !lines.isEmpty {
      let sectionLines: [String]
      if let nextBreak = lines.indices.dropFirst().first(where: { index in
        if lines[index] == "",
           let next = lines[index...].dropFirst().first,
           let startingCharacter = next.first,
           startingCharacter != " " {
          return true
        } else {
          return false
        }
      }) {
        sectionLines = Array(lines[..<nextBreak])
      } else {
        sectionLines = Array(lines)
      }
      lines.removeFirst(sectionLines.count)
      let section = "\n" + sectionLines.joined(separator: "\n")
      let sectionLength = section.utf8.count
      if !files.isEmpty,
        accumulatedBytes + sectionLength < fileSizeLimit! {
        accumulatedBytes += sectionLength
      } else {
        files.append(imports)
        accumulatedBytes = importsLength + sectionLength
      }
      files[files.indices.last!].append(contentsOf: section)
    }
    return files.map { postprocessFileSplit($0) }
  }
  static func postprocessFileSplit(_ file: String) -> String {
    return file
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
        source.appendSeparatorLine()
        source.append(contentsOf: entryPoint)
      }
      let constructionDirectory = location ?? preparedDirectory(for: package)
      let completedSource = source.joined(separator: "\n").appending("\n")
      let sourceFileURL = constructionDirectory.appendingPathComponent(sourceFileName)
      if let limit = fileSizeLimit,
        completedSource.utf8.count > limit {
        let split = splitLongFile(completedSource)
        let fileExtension = sourceFileURL.pathExtension
        let withoutExtension = sourceFileURL.deletingPathExtension()
        let name = withoutExtension.lastPathComponent
        let directory = withoutExtension.deletingLastPathComponent()
        for (index, part) in split.enumerated() {
          try part.save(
            to: directory.appendingPathComponent("\(name)\(index + 1)").appendingPathExtension(fileExtension)
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
