import SDGLogic
import SDGCollections
import SDGText

enum Swift {

  #warning("Can sanitization be unified too?")
  static let identifierStartList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(contentsOf: 0x41...0x5A) // A–Z
    values.append(contentsOf: 0x61...0x7A) // a–z
    values.append(0x5F) // _
    values.append(0xA8)
    values.append(0xAA)
    values.append(0xAD)
    values.append(0xAF)
    values.append(contentsOf: 0xB2...0xB5)
    values.append(contentsOf: 0xB7...0xBA)
    values.append(contentsOf: 0xBC...0xBE)
    values.append(contentsOf: 0xC0...0xD6)
    values.append(contentsOf: 0xD8...0xF6)
    values.append(contentsOf: 0xF8...0xFF)
    values.append(contentsOf: 0x100...0x2FF)
    values.append(contentsOf: 0x370...0x167F)
    values.append(contentsOf: 0x1681...0x180D)
    values.append(contentsOf: 0x180F...0x1DBF)
    values.append(contentsOf: 0x1E00...0x1FFF)
    values.append(contentsOf: 0x200B...0x200D)
    values.append(contentsOf: 0x202A...0x202E)
    values.append(contentsOf: 0x203F...0x2040)
    values.append(0x2054)
    values.append(contentsOf: 0x2060...0x206F)
    values.append(contentsOf: 0x2070...0x20CF)
    values.append(contentsOf: 0x2100...0x218F)
    values.append(contentsOf: 0x2460...0x24FF)
    values.append(contentsOf: 0x2776...0x2793)
    values.append(contentsOf: 0x2C00...0x2DFF)
    values.append(contentsOf: 0x2E80...0x2FFF)
    values.append(contentsOf: 0x3004...0x3007)
    values.append(contentsOf: 0x3021...0x302F)
    values.append(contentsOf: 0x3031...0x303F)
    values.append(contentsOf: 0x3040...0xD7FF)
    values.append(contentsOf: 0xF900...0xFD3D)
    values.append(contentsOf: 0xFD40...0xFDCF)
    values.append(contentsOf: 0xFDF0...0xFE1F)
    values.append(contentsOf: 0xFE30...0xFE44)
    values.append(contentsOf: 0xFE47...0xFFFD)
    values.append(contentsOf: 0x10000...0x1FFFD)
    values.append(contentsOf: 0x20000...0x2FFFD)
    values.append(contentsOf: 0x30000...0x3FFFD)
    values.append(contentsOf: 0x40000...0x4FFFD)
    values.append(contentsOf: 0x50000...0x5FFFD)
    values.append(contentsOf: 0x60000...0x6FFFD)
    values.append(contentsOf: 0x70000...0x7FFFD)
    values.append(contentsOf: 0x80000...0x8FFFD)
    values.append(contentsOf: 0x90000...0x9FFFD)
    values.append(contentsOf: 0xA0000...0xAFFFD)
    values.append(contentsOf: 0xB0000...0xBFFFD)
    values.append(contentsOf: 0xC0000...0xCFFFD)
    values.append(contentsOf: 0xD0000...0xDFFFD)
    values.append(contentsOf: 0xE0000...0xEFFFD)
    return Set(
      values.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          ¬scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }()
  static func identifierStartAllowed(_ scalar: Unicode.Scalar) -> Bool {
    return scalar ∈ identifierStartList
  }

  static let identifierAllowedList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(contentsOf: identifierStartList.lazy.map({ $0.value }))
    values.append(contentsOf: 0x30...0x39) // 0–9
    values.append(contentsOf: 0x300...0x36F)
    values.append(contentsOf: 0x1DC0...0x1DFF)
    values.append(contentsOf: 0x20D0...0x20FF)
    values.append(contentsOf: 0xFE20...0xFE2F)
    return Set(
      values.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          ¬scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }()
  static func identifierAllowed(_ scalar: Unicode.Scalar) -> Bool {
    return scalar ∈ identifierAllowedList
  }
  
  static func sanitize(identifier: StrictString, leading: Bool) -> String {
    var result: StrictString = identifier.lazy
      .map({ identifierAllowed($0) ∧ $0 ≠ "_" ? "\($0)" : "_\($0.hexadecimalCode)" })
      .joined()
    if leading,
      let first = result.first,
      identifierStartAllowed(first) {
      result.removeFirst()
      result.prepend(contentsOf: "_\(first.hexadecimalCode)")
    }
    return String(result)
  }
}

extension Swift: Platform {
  static func nativeName(of thing: Thing) -> StrictString? {
    return thing.swift
  }
  static func nativeImplementation(of action: ActionIntermediate) -> SwiftImplementation? {
    return action.swift
  }
  static func source(for parameter: ParameterIntermediate, module: ModuleIntermediate) -> String {
    return parameter.swiftSource(module: module)
  }
  static var emptyReturnType: String? {
    return nil
  }
  static func returnSection(with returnValue: String) -> String? {
    return " -> \(returnValue)"
  }
  static func coverageRegistration(identifier: String) -> String {
    return "  registerCoverage(\u{22}\(identifier)\u{22})"
  }
  static func statement(expression: ActionUse, context: ActionIntermediate, module: ModuleIntermediate) -> String {
    return actionUse.swiftExpression(context: context, module: module)
  }
  static func actionDeclaration(name: String, parameters: String, returnSection: String?, returnKeyword: String?, coverageRegistration: String?, implementation: String) -> String {
    var result: [String] = [
      "func \(name)(\(parameters))\(returnSection ?? "") {",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    result.append(contentsOf: [
      "  \(returnKeyword ?? "")\(implementation)",
      "}",
    ])
    return result.joined(separator: "\n")
  }
}
