import Foundation

enum C: Platform {

  static var directoryName: String {
    return "C"
  }
  static var indent: String {
    return "        "
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
    values.append(0x22) // "
    values.append(0xC5) // \
    return values
  }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>?
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>?
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>?

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    var digits = String(character.value, radix: 16, uppercase: true)
    digits.scalars.fill(to: 8, with: "0", from: .start)
    return "\u{5C}U\(digits)"
  }

  static func literal(string: String) -> String {
    return "reference_string(g_string_new(\u{22}\(string)\u{22}))"
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

  static func nativeName(of thing: Thing) -> String? {
    return nil
  }
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate? {
    return thing.c
  }
  static func repair(compoundNativeType: String) -> String {
    return compoundNativeType
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    return "\(returnValue) (*)(\(parameters))"
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    return nil
  }

  static func thingDeclaration(
    name: String,
    components: [String],
    accessModifier: String?,
    constructorParameters: [String],
    constructorAccessModifier: String?,
    constructorSetters: [String],
    otherMembers: [String]
  ) -> String? {
    var result: [String] = [
      "typedef struct \(name) {"
    ]
    for component in components {
      result.append("\(indent)\(component)")
    }
    result.append(contentsOf: [
      "} \(name);"
    ])
    return result.joined(separator: "\n")
  }
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    simple: Bool,
    storageCases: [String],
    otherMembers: [String]
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
        enumerationTypeDeclaration(name: "\(name)_case", cases: cases, simple: true, storageCases: [], otherMembers: [])
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
          otherMembers: []
        )!
      )
      
      return result.joined(separator: "\n")
    }
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
    let constant = isThrough ? "" : "const "
    let pointer = isThrough ? "*" : ""
    return "\(constant)\(type)\(pointer) \(name)"
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
  static func passReference(to argument: String, forwarding: Bool) -> String {
    return "&\(argument)"
  }
  static func unpackReference(to argument: String) -> String? {
    return nil
  }
  static func dereference(throughParameter: String, forwarding: Bool) -> String {
    return "*\(throughParameter)"
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

  static var importsNeededByMemoryManagement: Set<String> {
    return [
      "err",
      "stdlib",
    ]
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

  static var memoryManagement: String? {
    return [
      "#define REFERENCE_COUNTING(type, name, clean_up, ...) \u{5C}",
      "typedef struct reference_counted_ ## name { \u{5C}",
      "\(indent)type target; \u{5C}",
      "\(indent)unsigned references; \u{5C}",
      "} reference_counted_ ## name; \u{5C}",
      "\u{5C}",
      "reference_counted_ ## name* reference_ ## name(type target) { \u{5C}",
      "\(indent)reference_counted_ ## name* reference = malloc(sizeof(reference_counted_ ## name)); \u{5C}",
      "\(indent)if (reference == NULL) { \u{5C}",
      "\(indent)\(indent)err(EXIT_FAILURE, \u{22}malloc\u{22}); \u{5C}",
      "\(indent)} \u{5C}",
      "\(indent)reference->target = target; \u{5C}",
      "\(indent)reference->references = 1; \u{5C}",
      "\(indent)return reference; \u{5C}",
      "} \u{5C}",
      "\u{5C}",
      "reference_counted_ ## name* hold_ ## name(reference_counted_ ## name* reference) { \u{5C}",
      "\(indent)reference->references += 1; \u{5C}",
      "\(indent)return reference; \u{5C}",
      "} \u{5C}",
      "\u{5C}",
      "void release_ ## name(reference_counted_ ## name* reference) { \u{5C}",
      "\(indent)reference->references -= 1; \u{5C}",
      "\(indent)if (reference->references == 0) { \u{5C}",
      "\(indent)\(indent)clean_up(reference->target, __VA_ARGS__); \u{5C}",
      "\(indent)\(indent)free(reference); \u{5C}",
      "\(indent)} \u{5C}",
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

  static func testSource(identifier: String, statements: [String]) -> [String] {
    var result: [String] = [
      "void run_\(identifier)()",
      "{",
    ]
    for statement in statements {
      result.append("\(indent)\(statement)")
    }
    result.append("}")
    return result
  }
  static func testCall(for identifier: String) -> String {
    return "run_\(identifier)();"
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
