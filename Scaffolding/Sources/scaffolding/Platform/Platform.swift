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
  static func escapeForStringLiteral(character: Unicode.Scalar) -> String

  // Access
  static func accessModifier(for access: AccessIntermediate, memberScope: Bool) -> String?

  // Parts
  static func partDeclaration(
    name: String,
    type: String,
    accessModifier: String?
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
  static func actionType(parameters: String, returnValue: String) -> String
  static func actionReferencePrefix(isVariable: Bool) -> String?
  static func thingDeclaration(
    name: String,
    components: [String],
    accessModifier: String?,
    constructorParameters: [String],
    constructorAccessModifier: String?,
    constructorSetters: [String]
  ) -> String?
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    simple: Bool,
    storageCases: [String]
  ) -> String

  // Actions
  static func nativeName(of action: ActionIntermediate) -> String?
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String?
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate?
  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String
  static func createInstance(of type: String, parts: String) -> String
  static func constructorSetter(name: String) -> String
  static var needsReferencePreparation: Bool { get }
  static func prepareReference(to argument: String, update: Bool) -> String?
  static func passReference(to argument: String) -> String
  static func unpackReference(to argument: String) -> String?
  static func dereference(throughParameter: String) -> String
  static var emptyReturnType: String? { get }
  static var emptyReturnTypeForActionType: String { get }
  static func returnSection(with returnValue: String) -> String?
  static var needsForwardDeclarations: Bool { get }
  static func forwardActionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?
  ) -> String?
  static func coverageRegistration(identifier: String) -> String
  static func statement(expression: String) -> String
  static func returnDelayStorage(type: String?) -> String
  static var delayedReturn: String { get }
  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    accessModifier: String?,
    coverageRegistration: String?,
    implementation: [String]
  ) -> String

  // Imports
  static var fileSettings: String? { get }
  static func statementImporting(_ importTarget: String) -> String

  // Native Requirements
  static var preexistingNativeRequirements: Set<String> { get }

  // Module
  static var importsNeededByTestScaffolding: Set<String> { get }
  static func coverageRegionSet(regions: [String]) -> [String]
  static var registerCoverageAction: [String] { get }
  static var actionDeclarationsContainerStart: [String]? { get }
  static var actionDeclarationsContainerEnd: [String]? { get }
  static func testSource(identifier: String, statements: [String]) -> [String]
  static func testCall(for identifier: String) -> String
  static func testSummary(testCalls: [String]) -> [String]

  // Package
  static func testEntryPoint() -> [String]?
  static var sourceFileName: String { get }
  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws
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
    var result: String = StrictString(identifier).lazy
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

  static func sanitize(stringLiteral: UnicodeText) -> String {
    return StrictString(stringLiteral).lazy
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
        return String(native.textComponents.lazy.map({ StrictString($0) }).joined())
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
          result.append(contentsOf: String(StrictString(native.textComponents[index])))
          if index != native.textComponents.indices.last {
            let type = native.parameters[index].resolvedType!
            result.append(contentsOf: source(for: type, referenceLookup: referenceLookup))
          }
        }
        return result
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
    alreadyHandledNativeRequirements: inout Set<String>
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
        return enumerationCase.referenceAction.map({ nativeImplementation(of: $0) }) != nil
      }) {
      return nil
    }

    let name = nativeName(of: thing) ?? sanitize(
      identifier: thing.globallyUniqueIdentifier(referenceLookup: externalReferenceLookup),
      leading: true
    )
    if thing.cases.isEmpty {
      let components = thing.parts.map({ part in
        let name = sanitize(
          identifier: part.names.identifier(),
          leading: true
        )
        let type = source(for: part.contents, referenceLookup: externalReferenceLookup)
        let access = accessModifier(for: part.access, memberScope: true)
        return partDeclaration(name: name, type: type, accessModifier: access)
      })
      let access = accessModifier(for: thing.access, memberScope: false)
      let constructorParameters = thing.parts.map({ part in
        let name = sanitize(
          identifier: part.names.identifier(),
          leading: true
        )
        let type = source(for: part.contents, referenceLookup: externalReferenceLookup)
        return parameterDeclaration(label: nil, name: name, type: type, isThrough: false)
      })
      let constructorAccess = accessModifier(for: externalReferenceLookup.lookupCreation(of: thing)?.access ?? .file, memberScope: true)
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
        constructorSetters: constructorSetters
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
      return enumerationTypeDeclaration(name: name, cases: cases, simple: thing.isSimple, storageCases: storageCases)
    }
  }

  static func flowCoverageRegistration(
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int
  ) -> String? {
    coverageRegionCounter += 1
    if let coverage = contextCoverageIdentifier {
      let appendedIdentifier: StrictString = "\(StrictString(coverage)):{\(coverageRegionCounter.inDigits())}"
      return "\n\(self.coverageRegistration(identifier: sanitize(stringLiteral: UnicodeText(appendedIdentifier))))"
    } else {
      return nil
    }
  }

  static func call(
    to reference: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    extractedArguments: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [StrictString: String],
    mode: CompilationMode
  ) -> String {
    let signature = reference.arguments.map({ $0.resolvedResultType!! })
    if let inlined = inliningArguments[StrictString(reference.actionName)] {
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
      if parameter.passAction.returnValue?.key.resolving(fromReferenceLookup: referenceLookup)
        == reference.resolvedResultType!?.key.resolving(fromReferenceLookup: referenceLookup) {
        let name = String(sanitize(identifier: parameter.names.identifier(), leading: true))
        if parameter.isThrough {
          return dereference(throughParameter: name)
        } else {
          return name
        }
      } else {
        return call(
          to: parameter.executeAction!,
          reference: reference,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          parameterName: parameter.names.identifier(),
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          extractedArguments: &extractedArguments,
          cleanUpCode: &cleanUpCode,
          inliningArguments: [:],
          mode: mode
        )
      }
    } else {
      let bareAction = referenceLookup.lookupAction(
        reference.actionName,
        signature: signature,
        specifiedReturnValue: reference.resolvedResultType
      )!
      let action = mode != .testing || (context?.isCoverageWrapper ?? false)
        ? bareAction
        : referenceLookup.lookupAction(
          bareAction.coverageTrackingIdentifier(),
          signature: signature,
          specifiedReturnValue: reference.resolvedResultType
        )!
      if !extractedArguments.isEmpty,
        let result = action.returnValue,
        let type = referenceLookup.lookupThing(result.key),
        let native = nativeType(of: type),
        native.release != nil {
        return extractedArguments.removeFirst()
      }
      var result: [String] = [
        call(
          to: bareAction.isFlow ? bareAction : action,
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
    reference: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    parameterName: UnicodeText?,
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    extractedArguments: inout [String],
    cleanUpCode: inout String,
    inliningArguments: [StrictString: String],
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
      for index in native.textComponents.indices {
        accumulator.append(contentsOf: String(StrictString(native.textComponents[index])))
        if index != native.textComponents.indices.last {
          let parameter = native.parameters[index]
          if let type = parameter.typeInstead {
            let typeSource = source(for: type, referenceLookup: referenceLookup)
            accumulator.append(contentsOf: typeSource)
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
            if let argumentIndex = usedParameters.firstIndex(where: { $0.names.contains(StrictString(name)) }) {
              let argument = reference.arguments[argumentIndex]
              switch argument {
              case .action(let actionArgument):
                accumulator.append(
                  contentsOf: call(
                    to: actionArgument,
                    context: context,
                    localLookup: localLookup.appending(local),
                    referenceLookup: referenceLookup,
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter,
                    clashAvoidanceCounter: &clashAvoidanceCounter,
                    extractedArguments: &extractedArguments,
                    cleanUpCode: &cleanUpCode,
                    inliningArguments: inliningArguments,
                    mode: mode
                  )
                )
              case .flow(let statements):
                if mode == .testing,
                   let coverage = flowCoverageRegistration(
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter
                   ) {
                  accumulator.append(coverage)
                }
                accumulator.append("\n")
                var existingReferences: Set<String> = []
                for statement in statements.statements {
                  accumulator.append(
                    source(
                      for: statement,
                      context: context,
                      localLookup: localLookup.appending(local),
                      referenceLookup: referenceLookup,
                      contextCoverageIdentifier: contextCoverageIdentifier,
                      coverageRegionCounter: &coverageRegionCounter,
                      clashAvoidanceCounter: &clashAvoidanceCounter,
                      cleanUpCode: &cleanUpCode,
                      inliningArguments: inliningArguments,
                      existingReferences: &existingReferences,
                      mode: mode,
                      indentationLevel: 1
                    )
                  )
                  accumulator.append("\n")
                }
              }
              let newActions = argument.localActions()
              for new in newActions {
                _ = local.add(action: new)
              }
              if !newActions.isEmpty {
                local.resolveTypeIdentifiers(externalLookup: referenceLookup.appending(contentsOf: localLookup))
              }
            } else {
              if StrictString(name) == "+" {
                accumulator.append(String(clashAvoidanceCounter))
                didUseClashAvoidance = true
              } else if StrictString(name) == "−" {
                beforeCleanUp = accumulator
                accumulator = ""
              } else {
                fatalError()
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
      let name = sanitize(identifier: action.names.identifier(), leading: true)
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
      var newInliningArguments: [StrictString: String] = [:]
      var locals = ReferenceDictionary()
      for index in parameters.indices {
        let parameter = parameters[index]
        let argument = reference.arguments[index]
        switch argument {
        case .action(let action):
          newInliningArguments[StrictString(parameter.names.identifier())] = call(
            to: action,
            context: context,
            localLookup: localLookup.appending(locals),
            referenceLookup: referenceLookup,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            extractedArguments: &extractedArguments,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
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
            coverageRegionCounter: &coverageRegionCounter
          ) {
            source.prepend(coverage)
          }
          newInliningArguments[StrictString(parameter.names.identifier())] = source.joined(separator: "\n")
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
      let name = nativeName(of: action) ?? sanitize(
        identifier: parameterName
          ?? action.globallyUniqueIdentifier(referenceLookup: referenceLookup),
        leading: true
      )
      if action.isReferenceWrapper {
        let prefix = actionReferencePrefix(isVariable: parameterName != nil) ?? ""
        return "\(prefix)\(name)"
      } else {
        var argumentsArray: [String] = []
        let parameters = action.parameters.ordered(for: action.names.identifier())
        for argumentIndex in reference.arguments.indices {
          let argument = reference.arguments[argumentIndex]
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
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter,
                    clashAvoidanceCounter: &clashAvoidanceCounter,
                    extractedArguments: &extractedArguments,
                    cleanUpCode: &cleanUpCode,
                    inliningArguments: inliningArguments,
                    mode: mode
                  )
                )
              )
            } else {
              argumentsArray.append(
                parameterLabel + call(
                  to: actionArgument,
                  context: context,
                  localLookup: localLookup,
                  referenceLookup: referenceLookup,
                  contextCoverageIdentifier: contextCoverageIdentifier,
                  coverageRegionCounter: &coverageRegionCounter,
                  clashAvoidanceCounter: &clashAvoidanceCounter,
                  extractedArguments: &extractedArguments,
                  cleanUpCode: &cleanUpCode,
                  inliningArguments: inliningArguments,
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
          let arguments = argumentsArray.joined(separator: ", ")
          return createInstance(of: type, parts: arguments)
        } else {
          let nameStart = name.unicodeScalars.first(where: { $0 != "_" }).map({ String($0) }) ?? ""
          if sanitize(identifier: UnicodeText(StrictString(nameStart)), leading: false) != nameStart {
            return "(\(argumentsArray.joined(separator: " \(name) ")))"
          } else {
            let arguments = argumentsArray.joined(separator: ", ")
            return "\(name)(\(arguments))"
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
    inliningArguments: [StrictString: String],
    mode: CompilationMode
  ) -> [ReferenceCountedReturn] {
    var entries: [ReferenceCountedReturn] = []
    for argument in action.arguments {
      switch argument {
      case .action(let action):
        if localLookup.lookupAction(
          action.actionName,
          signature: action.arguments.map({ $0.resolvedResultType!! }),
          specifiedReturnValue: action.resolvedResultType,
          externalLookup: referenceLookup
        ) != nil {
          continue
        } else if context?.lookupParameter(action.actionName) != nil {
          continue
        } else {
          entries.append(
            contentsOf: argumentsExtractedForReferenceCounting(
              from: action,
              context: context,
              localLookup: localLookup,
              referenceLookup: referenceLookup,
              contextCoverageIdentifier: contextCoverageIdentifier,
              coverageRegionCounter: &coverageRegionCounter,
              clashAvoidanceCounter: &clashAvoidanceCounter,
              cleanUpCode: &cleanUpCode,
              inliningArguments: inliningArguments,
              mode: mode
            )
          )
        }

        if let result = argument.resolvedResultType,
          let actualResult = result,
          let type = referenceLookup.lookupThing(actualResult.key),
          let native = nativeType(of: type),
           let release = native.release {
          let localName = "local"
          let typeName = source(for: actualResult, referenceLookup: referenceLookup)
          var extracted: [String] = []
          let call = self.call(
            to: action,
            context: context,
            localLookup: localLookup,
            referenceLookup: referenceLookup,
            contextCoverageIdentifier: contextCoverageIdentifier,
            coverageRegionCounter: &coverageRegionCounter,
            clashAvoidanceCounter: &clashAvoidanceCounter,
            extractedArguments: &extracted,
            cleanUpCode: &cleanUpCode,
            inliningArguments: inliningArguments,
            mode: mode
          )
          let releaseName = String(StrictString(release))
          entries.append(
            ReferenceCountedReturn(
              localStorageDeclaration: "const \(typeName) \(localName) = \(call);",
              localName: localName,
              releaseStatement: "\(releaseName)(\(localName));"
            )
          )
        }
      case .flow:
        break
      }
    }
    return entries
  }

  static func source(
    for statement: StatementIntermediate,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: UnicodeText?,
    coverageRegionCounter: inout Int,
    clashAvoidanceCounter: inout Int,
    cleanUpCode: inout String,
    inliningArguments: [StrictString: String],
    existingReferences: inout Set<String>,
    mode: CompilationMode,
    indentationLevel: Int
  ) -> String {
    var entry = ""
    var referenceList: [String] = []
    if needsReferencePreparation {
      referenceList = statement.passedReferences().map { reference in
        var extracted: [String] = []
        return call(
          to: reference,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          extractedArguments: &extracted,
          cleanUpCode: &cleanUpCode,
          inliningArguments: inliningArguments,
          mode: mode
        )
      }
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
      from: statement.action,
      context: context,
      localLookup: localLookup,
      referenceLookup: referenceLookup,
      contextCoverageIdentifier: contextCoverageIdentifier,
      coverageRegionCounter: &coverageRegionCounter,
      clashAvoidanceCounter: &clashAvoidanceCounter,
      cleanUpCode: &cleanUpCode,
      inliningArguments: inliningArguments,
      mode: mode
    )
    if !extractedArguments.isEmpty {
      for argument in extractedArguments {
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
            type: statement.action.resolvedResultType!
              .map({ source(for: $0, referenceLookup: referenceLookup) })
          )
        )
      }
    }
    let before = coverageRegionCounter
    var remainingExtractedArguments = extractedArguments.map({ $0.localName })
    entry.append(
      contentsOf: self.statement(
        expression: call(
          to: statement.action,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter,
          clashAvoidanceCounter: &clashAvoidanceCounter,
          extractedArguments: &remainingExtractedArguments,
          cleanUpCode: &cleanUpCode,
          inliningArguments: inliningArguments,
          mode: mode
        )
      )
    )
    if mode == .testing,
      coverageRegionCounter != before,
       let coverage = flowCoverageRegistration(
        contextCoverageIdentifier: contextCoverageIdentifier,
        coverageRegionCounter: &coverageRegionCounter
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
    let presentIndent = String(repeating: indent, count: indentationLevel)
    entry.scalars.replaceMatches(for: "\n".scalars.literal(), with: "\n\(presentIndent)".scalars)
    return entry.prepending(contentsOf: presentIndent)
  }

  static func source(
    for parameter: ParameterIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    let name = sanitize(identifier: parameter.names.identifier(), leading: true)
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

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0) })

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
    inliningArguments: [StrictString: String],
    mode: CompilationMode,
    indentationLevel: Int
  ) -> [String] {
    var locals = ReferenceDictionary()
    var cleanUpCode = ""
    var existingReferences: Set<String> = []
    var inOrder = statements.map({ entry in
      let result = source(
        for: entry,
        context: context,
        localLookup: localLookup.appending(locals),
        referenceLookup: referenceLookup.appending(locals),
        contextCoverageIdentifier: context?.coverageRegionIdentifier(referenceLookup: referenceLookup),
        coverageRegionCounter: &coverageRegionCounter,
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
    alreadyHandledNativeRequirements: inout Set<String>
  ) -> String? {
    if action.isMemberWrapper {
      return nil
    }
    if let native = nativeImplementation(of: action) {
      return source(for: native.requiredDeclarations, referenceLookup: externalReferenceLookup, alreadyHandled: &alreadyHandledNativeRequirements)
    }

    guard let actionImplementation = action.implementation else {
      // creation
      return nil
    }

    let name = nativeName(of: action)
      ?? sanitize(
        identifier: action.globallyUniqueIdentifier(referenceLookup: externalReferenceLookup),
        leading: true
      )
    let parameters = action.parameters.ordered(for: action.names.identifier())
      .lazy.map({ source(for: $0, referenceLookup: externalReferenceLookup) })
      .joined(separator: ", ")

    let returnValue: String?
    if let specified = action.returnValue {
      returnValue = source(for: specified, referenceLookup: externalReferenceLookup)
    } else {
      returnValue = emptyReturnType
    }

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0) })

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
      implementation: implementation
    )
  }

  static func identifier(for test: TestIntermediate, leading: Bool) -> String {
    return test.location.lazy.enumerated()
      .map({ sanitize(identifier: $1.identifier(), leading: leading && $0 == 0) })
      .joined(separator: "_")
  }

  static func source(of test: TestIntermediate, referenceLookup: [ReferenceDictionary]) -> [String] {
    var coverageRegionCounter = 0
    var clashAvoidanceCounter = 0
    return testSource(
      identifier: identifier(for: test, leading: false),
      statements: source(
        for: test.statements,
        context: nil,
        localLookup: [],
        coverageRegionCounter: &coverageRegionCounter,
        clashAvoidanceCounter: &clashAvoidanceCounter,
        referenceLookup: referenceLookup,
        inliningArguments: [:],
        mode: .testing,
        indentationLevel: 0
      )
    )
  }

  static func call(test: TestIntermediate) -> String {
    return testCall(for: identifier(for: test, leading: false))
  }

  static func nativeImports(for referenceDictionary: ReferenceDictionary) -> Set<String> {
    var imports: Set<String> = []
    for thing in referenceDictionary.allThings() {
      if let requiredImport = nativeType(of: thing)?.requiredImport {
        imports.insert(String(StrictString(requiredImport)))
      }
    }
    for action in referenceDictionary.allActions() {
      if let requiredImport = nativeImplementation(of: action)?.requiredImport {
        imports.insert(String(StrictString(requiredImport)))
      }
    }
    return imports
  }

  static func coverageRegions(for module: ModuleIntermediate, moduleWideImports: [ReferenceDictionary]) -> Set<StrictString> {
    let moduleReferenceLookup = module.referenceDictionary
    let allLookup = moduleWideImports.appending(moduleReferenceLookup)
    let actionRegions: [StrictString] = moduleReferenceLookup.allActions()
      .lazy.filter({ action in
        return !action.isCoverageWrapper
        && !(action.isFlow && action.returnValue != nil)
      })
      .lazy.flatMap({ $0.allCoverageRegionIdentifiers(referenceLookup: allLookup, skippingSubregions: nativeImplementation(of: $0) != nil).lazy.map({ StrictString($0) }) })
    let choiceRegions: [StrictString] = moduleReferenceLookup.allAbilities()
      .lazy.flatMap({ $0.defaults.values })
      .lazy.flatMap({ $0.allCoverageRegionIdentifiers(referenceLookup: allLookup, skippingSubregions: nativeImplementation(of: $0) != nil).lazy.map({ StrictString($0) }) })
    return Set([
      actionRegions,
      choiceRegions
    ].joined())
  }

  static func source(
    for nativeRequirements: [NativeRequirementImplementationIntermediate],
    referenceLookup: [ReferenceDictionary],
    alreadyHandled: inout Set<String>
  ) -> String? {
    var result: [String] = []
    for declaration in nativeRequirements {
      var line = ""
      for index in declaration.textComponents.indices {
        line.append(contentsOf: String(StrictString(declaration.textComponents[index])))
        if index != declaration.textComponents.indices.last {
          let type = declaration.parameters[index].resolvedType!
          line.append(contentsOf: source(for: type, referenceLookup: referenceLookup))
        }
      }
      if alreadyHandled.insert(line).inserted {
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
    alreadyHandledNativeRequirements: inout Set<String>
  ) -> String {
    var result: [String] = []
    let moduleReferenceLookup = moduleWideImports.appending(module.referenceDictionary)
    let allThings = module.referenceDictionary.allThings(sorted: true)
    for thing in allThings {
      if let declaration = self.declaration(for: thing, externalReferenceLookup: moduleReferenceLookup, alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements) {
        result.append(contentsOf: [
          "",
          declaration
        ])
      }
    }
    return result.joined(separator: "\n")
  }

  static func actionsSource(for module: ModuleIntermediate, mode: CompilationMode, moduleWideImports: [ReferenceDictionary], alreadyHandledNativeRequirements: inout Set<String>) -> String {
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
        alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements
      ) {
        result.append(contentsOf: [
          "",
          declaration
        ])
      }
    }
    if mode == .testing {
      let allTests = module.allTests(sorted: true)
      for test in allTests {
        result.append("")
        result.append(contentsOf: source(of: test, referenceLookup: referenceLookup))
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
    imports.formUnion(importsNeededByTestScaffolding)
    if !imports.isEmpty {
      for importTarget in imports.sorted() {
        result.append(statementImporting(importTarget))
      }
      result.append("")
    }

    if mode == .testing {
      var regionSet: Set<StrictString> = []
      for module in modules {
        regionSet.formUnion(self.coverageRegions(for: module, moduleWideImports: moduleWideImportDictionary))
      }
      let regions = regionSet
        .sorted()
        .map({ sanitize(stringLiteral: UnicodeText($0)) })
      result.append(contentsOf: coverageRegionSet(regions: regions))
      result.append(contentsOf: registerCoverageAction)
    }

    for module in modules {
      result.append(typesSource(for: module, moduleWideImports: moduleWideImportDictionary, alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements))
    }

    if let start = actionDeclarationsContainerStart {
      result.append("")
      result.append(contentsOf: start)
    }
    for module in modules {
      result.append(self.actionsSource(for: module, mode: mode, moduleWideImports: moduleWideImportDictionary, alreadyHandledNativeRequirements: &alreadyHandledNativeRequirements))
    }
    if mode == .testing {
      var allTests: [TestIntermediate] = []
      for module in modules {
        allTests.append(contentsOf: module.allTests(sorted: true))
      }
      result.append("")
      result.append(contentsOf: testSummary(testCalls: allTests.map({ call(test: $0) })))
    }
    if let end = actionDeclarationsContainerEnd {
      result.append(contentsOf: end)
    }

    return result.joined(separator: "\n").appending("\n")
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
    entryPoints: Set<StrictString>? = nil,
    location: URL? = nil
  ) throws {
    let sourceModules = try package.modules()
    var noEntryPoints: Set<StrictString>? = nil
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
      try source.joined(separator: "\n").appending("\n")
        .save(to: constructionDirectory.appendingPathComponent(sourceFileName))
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
