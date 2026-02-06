import Foundation

// Memory Management

// Memory is managed by reference counting.

// • The return value of any function is owned by the caller.
//   • This means anything received from a function must be released.
//       reference variable = callFunction();
//       release(variable);
//     • Note that passing directly from a return value to an argument would cause a leak.
//         callOuterFunction(callInnerFunction());
//       Instead:
//         reference variable = callInnerFunction();
//         callOuterFunction(variable);
//         release(variable);
//   • This means anything sent out of a function by return must be under a hold.
//       return hold(constant);
//     • Note that most often ownership is already there from a function call.
//         return callFunction();
//   • Note that this rule describes even the hold() and copy() functions.
// • Any storage must own its contents.
//     uninitialized_storage = hold(constant);
//   • This means swapping contents must release the old contents and hold the new.
//     release(existing_storage);
//     existing_storage = hold(new);
//   • This means when the storage is destroyed, it must release its contents.
//       release(structure->member);
//       structure = NULL;
//     • Note that most often this is centralized into a simple release of the parent.
//         release(structure);
//   • Note that this rule describes even passed references.
// • Holds and releases may be omitted in pairs, either by a code author or by compiler optimization, provided the pair is known from context to be unnecessary.
// • Memory‐managed types share data using the copy‐on‐write technique.
//     • A copy must be made before modification if other references may exist.
//     • Literals must be copied before modification.
//   • Copies are shallow.
//     • Immediate structure members and list elements of a copy are safe to replace entirely.
//     • Structure members and list elements must be replaced with a copy before nested modifications.
//   • detach() is shorthand for replacing with a copy and releasing the previous data.
//     • Its return value is the same reference, so that calls can succinctly be wrapped around arguments.
//       modify(detach(&value))

enum C: Platform {

  static var directoryName: String {
    return "C"
  }
  static var indent: String {
    return "        "
  }
  static var fileSizeLimit: Int? {
    return nil
  }

  static var allowsAllUnicodeIdentifiers: Bool {
    return false
  }
  static let allowedIdentifierStartGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(contentsOf: 0x41...0x5A) // A–Z
    values.append(contentsOf: 0x61...0x7A) // a–z
    values.append(0x5F) // _
    return values
  }
  static let additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(contentsOf: 0x30...0x39) // 0–9
    return values
  }
  static var disallowedStringLiteralPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x0) // null (compiler warning)
    values.append(0x22) // "
    values.append(0xC5) // \
    return values
  }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>?
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>?
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>?

  static var identifierLengthLimit: Int? {
    return nil
  }

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    var digits = String(character.value, radix: 16, uppercase: true)
    if character.value < 0xA0 {
      digits.scalars.fill(to: 2, with: "0", from: .start)
      return "\u{5C}x\(digits)"
    } else {
      digits.scalars.fill(to: 8, with: "0", from: .start)
      return "\u{5C}U\(digits)"
    }
  }

  static func literal(scalars: String, escaped: String) -> String {
    return "Unicode_scalars_literal(\u{22}\(escaped)\u{22}, \(scalars.utf8.count))"
  }
  static func literal(scalar: Unicode.Scalar) -> String {
    return "0x\(String(scalar.value, radix: 16, uppercase: true))"
  }
  static func literal(number: String, typeNames: Set<UnicodeText>) -> String {
    return number
  }

  static func accessModifier(for access: AccessIntermediate, memberScope: Bool) -> String? {
    return nil
  }

  static func partDeclaration(
    name: String,
    type: String,
    accessModifier: String?,
    noSetter: Bool
  ) -> String {
    return "\(type) \(name);"
  }

  static func caseReference(name: String, type: String, simple: Bool, ignoringValue: Bool) -> String {
    if simple {
      return "\(type)_\(name)"
    } else {
      if ignoringValue {
        return "\(type)_case_\(name)"
      } else {
        return "(\(type)) {\(type)_case_\(name)}"
      }
    }
  }
  static func caseDeclaration(
    name: String,
    contents: String?,
    index: Int,
    simple: Bool,
    parentType: String
  ) -> String {
    return "\(name),"
  }
  static var needsSeparateCaseStorage: Bool {
    return true
  }
  static func caseStorageDeclaration(name: String, contents: String, parentType: String) -> String? {
    return "\(contents) \(parentType)_case_\(name);"
  }

  static var isTyped: Bool {
    return true
  }

  static func nativeNameDeclaration(of thing: Thing) -> UnicodeText? {
    return thing.cName
  }
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate? {
    return thing.c
  }
  static func repair(compoundNativeType: String) -> String {
    return compoundNativeType
  }
  private static func synthesized(_ name: String, for thing: String) -> NativeActionExpressionIntermediate? {
    let prefix = identifierPrefix(for: thing)
    return NativeActionExpressionIntermediate(
      textComponents: ["\(prefix)_\(name)(", ")"],
      parameters: [
        NativeActionImplementationParameter(
          ParsedUninterruptedIdentifier(source: UnicodeText("thing"), origin: compilerGeneratedOrigin())!
        )
      ]
    )
  }
  static func synthesizedHold(on thing: String) -> NativeActionExpressionIntermediate? {
    return synthesized("hold", for: thing)
  }
  static func synthesizedRelease(of thing: String) -> NativeActionExpressionIntermediate? {
    return synthesized("release", for: thing)
  }
  static func synthesizedCopy(of thing: String) -> NativeActionExpressionIntermediate? {
    return synthesized("copy", for: thing)
  }
  static func synthesizedDetachment(from thing: String) -> NativeActionExpressionIntermediate? {
    return synthesized("detach", for: thing)
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    return "\(returnValue) (*)(\(parameters))"
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    return nil
  }

  static var infersConstructors: Bool {
    return true
  }
  static func detachDeclaration(
    name: String,
    copyOld: String,
    releaseOld: String
  ) -> String {
    actionDeclaration(
      name: String(String.UnicodeScalarView(synthesizedDetachment(from: name)!.textComponents.first!.dropLast())),
      parameters: "\(name)* reference",
      returnSection: "\(name)*",
      accessModifier: nil,
      coverageRegistration: nil,
      implementation: [
        "\(indent)\(name) old = *reference;",
        "\(indent)*reference = \(copyOld);",
        "\(indent)\(releaseOld);",
        "\(indent)return reference;",
      ],
      parentType: nil,
      isMutating: false,
      isAbsorbedMember: false,
      isOverride: false,
      propertyInstead: false,
      initializerInstead: false
    ).full
  }
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
  ) -> String? {
    var result: [String] = [
      "typedef struct \(name) {"
    ]
    for component in components {
      result.append("\(indent)\(component)")
    }
    if components.isEmpty {
      result.append("\(indent)char address_occupier;")
    }
    result.append(contentsOf: [
      "} \(name);"
    ])
    if synthesizeReferenceCounting {
      result.append(contentsOf: [
        "",
        actionDeclaration(
          name: String(String.UnicodeScalarView(synthesizedHold(on: name)!.textComponents.first!.dropLast())),
          parameters: "\(name) target",
          returnSection: name,
          accessModifier: nil,
          coverageRegistration: nil,
          implementation: componentHolds.map({"\(indent)\($0);"})
            .appending("\(indent)return target;"),
          parentType: nil,
          isMutating: false,
          isAbsorbedMember: false,
          isOverride: false,
          propertyInstead: false,
          initializerInstead: false
        ).full,
        "",
        actionDeclaration(
          name: String(String.UnicodeScalarView(synthesizedRelease(of: name)!.textComponents.first!.dropLast())),
          parameters: "\(name) target",
          returnSection: "void",
          accessModifier: nil,
          coverageRegistration: nil,
          implementation: componentReleases.map({"\(indent)\($0);"}),
          parentType: nil,
          isMutating: false,
          isAbsorbedMember: false,
          isOverride: false,
          propertyInstead: false,
          initializerInstead: false
        ).full,
        "",
        actionDeclaration(
          name: String(String.UnicodeScalarView(synthesizedCopy(of: name)!.textComponents.first!.dropLast())),
          parameters: "\(name) target",
          returnSection: name,
          accessModifier: nil,
          coverageRegistration: nil,
          implementation: [
            "\(indent)return \(apply(nativeReferenceCountingAction: synthesizedHold(on: name)!, around: "target", referenceLookup: []));"
          ],
          parentType: nil,
          isMutating: false,
          isAbsorbedMember: false,
          isOverride: false,
          propertyInstead: false,
          initializerInstead: false
        ).full,
      ])
    }
    if isReferenceCounted {
      result.append(contentsOf: [
        "",
        detachDeclaration(name: name, copyOld: copyOld!, releaseOld: releaseOld!),
      ])
    }
    return result.joined(separator: "\n")
  }
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
  ) -> String {
    if simple {
      var result: [String] = [
        "typedef enum \(name) {"
      ]
      for enumerationCase in cases {
        result.append("\(indent)\(name)_\(enumerationCase)")
      }
      result.append(contentsOf: [
        "} \(name);"
      ])
      return result.joined(separator: "\n")
    } else {
      var result: [String] = []
      result.append(
        enumerationTypeDeclaration(
          name: "\(name)_case",
          cases: cases,
          accessModifier: accessModifier,
          simple: true,
          storageCases: [],
          otherMembers: [],
          isReferenceCounted: false,
          synthesizeReferenceCounting: false,
          componentHolds: [],
          componentReleases: [],
          copyOld: nil,
          releaseOld: nil
        )
      )
      result.append("typedef union \(name)_value {")
      for enumerationCase in storageCases {
        result.append("\(indent)\(enumerationCase)")
      }
      result.append(contentsOf: [
        "} \(name)_value;",
      ])
      result.append(
        thingDeclaration(
          name: name,
          components: [
            partDeclaration(
              name: "enumeration_case",
              type: "\(name)_case",
              accessModifier: nil,
              noSetter: true
            ),
            partDeclaration(
              name: "value",
              type: "\(name)_value",
              accessModifier: nil,
              noSetter: true
            ),
          ],
          accessModifier: nil,
          constructorParameters: [],
          constructorAccessModifier: nil,
          constructorSetters: [],
          otherMembers: [],
          isReferenceCounted: isReferenceCounted,
          synthesizeReferenceCounting: synthesizeReferenceCounting,
          componentHolds: switchCases(componentHolds, parentType: name),
          componentReleases: switchCases(componentReleases, parentType: name),
          copyOld: copyOld,
          releaseOld: releaseOld
        )!
      )
      return result.joined(separator: "\n")
    }
  }
  private static func switchCases(_ enumerationCases: [(String, String)], parentType: String) -> [String] {
    var result: [String] = [
      "switch (target.enumeration_case)",
      "{"
    ]
    for entry in enumerationCases {
      result.append(contentsOf: [
        "case \(parentType)_case_\(entry.0):",
        "\(indent)\(entry.1);",
        "\(indent)break;",
      ])
    }
    result.append(contentsOf: [
      "}",
    ])
    return [result.joined(separator: "\n\(indent)")]
  }

  static func nativeNameDeclaration(of action: ActionIntermediate) -> UnicodeText? {
    return action.nativeNames.c
  }
  static func nativeName(of parameter: ParameterIntermediate) -> String? {
    return parameter.nativeNames.c.map({ String($0) })
  }
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String? {
    return nil
  }
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.c
  }

  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String {
    let pointer = isThrough ? "*" : ""
    return "\(type)\(pointer) \(name)"
  }
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String {
    "\(returnValue) (*\(name))(\(parameters))"
  }
  static func constructorSetter(name: String) -> String {
    return ""
  }
  static func createInstance(of type: String, parts: String) -> String {
    return "(\(type)) {\(parts)}"
  }
  static var needsReferencePreparation: Bool {
    return false
  }
  static func prepareReference(to argument: String, update: Bool) -> String? {
    return nil
  }
  static func passReference(to argument: String, forwarding: Bool, isAddressee: Bool) -> String {
    if forwarding {
      return argument
    } else {
      return "&\(argument)"
    }
  }
  static func unpackReference(to argument: String) -> String? {
    return nil
  }
  static func dereference(throughParameter: String, forwarding: Bool) -> String {
    let prefix = forwarding ? "" : "*"
    return "\(prefix)\(throughParameter)"
  }

  static var emptyReturnType: String? {
    return emptyReturnTypeForActionType
  }
  static var emptyReturnTypeForActionType: String {
    return "void"
  }
  static func returnSection(with returnValue: String, isProperty: Bool) -> String? {
    return returnValue
  }

  static func actionDeclarationBase(name: String, parameters: String, returnSection: String?) -> String {
    return "\(returnSection!) \(name)(\(parameters))"
  }
  static var needsForwardDeclarations: Bool { true }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    let base = actionDeclarationBase(name: name, parameters: parameters, returnSection: returnSection)
    return "\(base);"
  }

  static func coverageRegistration(identifier: String) -> String {
    return "register_coverage_region(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: String) -> String {
    return expression.appending(";")
  }
  static func deadEnd() -> String {
    "abort();"
  }
  static func returnDelayStorage(type: String?) -> String {
    if let type = type {
      return "\(type) returnValue = "
    } else {
      return ""
    }
  }
  static var delayedReturn: String {
    return " return returnValue;"
  }

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
  ) -> UniqueDeclaration {
    var result: [String] = [
      actionDeclarationBase(name: name, parameters: parameters, returnSection: returnSection),
      "{",
    ]
    let uniquenessDefinition = result
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    for statement in implementation {
      result.append(contentsOf: [
        "\(statement)",
      ])
    }
    result.append(contentsOf: [
      "}",
    ])
    return UniqueDeclaration(
      full: result.joined(separator: "\n"),
      uniquenessDefinition: uniquenessDefinition.joined(separator: "\n")
    )
  }

  static var fileSettings: String? {
    return nil
  }
  static func statementImporting(_ importTarget: String) -> String {
    var target = importTarget
    if target.contains("-") {
      target = String(target.prefix(upTo: "-")!.contents)
    }
    return "#include <\(target).h>"
  }

  static let preexistingNativeRequirements: Set<String> = []
  static func isAlgorithmicallyPreexistingNativeRequirement(source: String) -> Bool {
    return false
  }

  static var importsNeededByDeadEnd: Set<String> {
    return [
      "stdlib",
    ]
  }
  static var importsNeededByTestScaffolding: Set<String> {
    return [
      "assert",
      "stdbool",
      "stdio",
      "string",
    ]
  }

  static var currentTestVariable: String {
    return [
      "char* current_test;",
      "void assert_noting_test(bool condition)",
      "{",
      "\(indent)if (!condition) {",
      "\(indent)\(indent)printf(\u{22}%s\u{5C}n\u{22}, current_test);",
      "\(indent)\(indent)fflush(stdout);",
      "\(indent)\(indent)assert(false);",
      "\(indent)}",
      "}",
    ].joined(separator: "\n")
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = []
    result.append(contentsOf: [
      "#define REGION_IDENTIFIER_LENGTH \((regions.lazy.map({ String($0).utf8.count }).max() ?? 0) + 1)",
      "#define NUMBER_OF_REGIONS \(regions.count)",
      "char coverage_regions[NUMBER_OF_REGIONS][REGION_IDENTIFIER_LENGTH] = {",
    ])
    for region in regions {
      result.append("\(indent)\u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "};",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
    "void register_coverage_region(char identifier[REGION_IDENTIFIER_LENGTH])",
    "{",
    "\(indent)for(int index = 0; index < NUMBER_OF_REGIONS; index++)",
    "\(indent){",
    "\(indent)\(indent)if (!strcmp(coverage_regions[index], identifier))",
    "\(indent)\(indent){",
    "\(indent)\(indent)\(indent)memset(coverage_regions[index], 0, REGION_IDENTIFIER_LENGTH);",
    "\(indent)\(indent)}",
    "\(indent)}",
    "}",
    ]
  }
  
  static var actionDeclarationsContainerStart: [String]? {
    return nil
  }
  static var actionDeclarationsContainerEnd: [String]? {
    return nil
  }

  static func register(test: String) -> String {
    return "current_test = \u{22}\(sanitize(stringLiteral: test))\u{22};"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "void test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "\(indent)\(test)",
      ])
    }
    result.append(contentsOf: [
      "",
      "\(indent)bool any_remaining = false;",
      "\(indent)for(int index = 0; index < NUMBER_OF_REGIONS; index++) {",
      "\(indent)\(indent)if (coverage_regions[index][0] != 0)",
      "\(indent)\(indent){",
      "\(indent)\(indent)\(indent)printf(\u{22}%s\u{5C}n\u{22}, coverage_regions[index]);",
      "\(indent)\(indent)\(indent)fflush(stdout);",
      "\(indent)\(indent)\(indent)any_remaining = true;",
      "\(indent)\(indent)}",
      "\(indent)}",
      "\(indent)assert(!any_remaining);",
      "}",
    ])
    return result
  }

  static func testEntryPoint() -> [String]? {
    return [
      "int main() {",
      "\(indent)test();",
      "\(indent)return 0;",
      "}",
    ]
  }

  static var sourceFileName: String {
    return "test.c"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws {
    let dependencyList = dependencies
      .compactMap({ importTarget in
        if importTarget.contains("-") {
          return importTarget
        } else {
          return nil
        }
      })
    let cFlags = dependencyList
      .map({ "$(shell pkg-config --cflags \($0))" })
      .joined(separator: " ")
    let libs = dependencyList
      .map({ "$(shell pkg-config --libs \($0))" })
      .joined(separator: " ")
    try ([
      "CFLAGS = \(cFlags)",
      "LIBS = \(libs)",
      "",
      "test: test.c",
      "\u{9}cc $(CFLAGS) test.c -o test $(LIBS)",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("Makefile"))
  }

  static var usesSnakeCase: Bool {
    return true
  }
  static var permitsParameterLabels: Bool {
    return false
  }
  static var permitsOverloads: Bool {
    return false
  }
  static var emptyParameterLabel: UnicodeText {
    return ""
  }
  static var parameterLabelSuffix: UnicodeText {
    return ""
  }
  static var memberPrefix: UnicodeText? {
    return nil
  }
  static var overridePrefix: UnicodeText? {
    return nil
  }
  static var variablePrefix: UnicodeText? {
    return nil
  }
  static var initializerSuffix: UnicodeText? {
    return nil
  }
  static var initializerName: UnicodeText {
    return ""
  }
}
