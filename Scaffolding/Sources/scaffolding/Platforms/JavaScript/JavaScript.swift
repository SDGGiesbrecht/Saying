import SDGLogic
import SDGCollections
import SDGText

enum JavaScript {

  static let identifierStartList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x24) // $
    values.append(0x5F) // _
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
    return scalar ∈ identifierStartList ∨ scalar.properties.isIDStart
  }

  static let identifierAllowedList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x24) // $
    values.append(contentsOf: 0x200C...0x200D)
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
    return scalar ∈ identifierAllowedList ∨ scalar.properties.isIDContinue
  }

  static func sanitize(identifier: StrictString, leading: Bool) -> StrictString {
    var result: StrictString = identifier.lazy
      .map({ identifierAllowed($0) ∧ $0 ≠ "_" ? "\($0)" : "_\($0.hexadecimalCode)" })
      .joined()
    if leading,
      let first = result.first,
      identifierStartAllowed(first) {
      result.removeFirst()
      result.prepend(contentsOf: "_\(first.hexadecimalCode)")
    }
    return result
  }

  static let stringLiteralDisallowedList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x5C) // \
    values.append(0xD) // CR
    values.append(0xA) // LF
    values.append(0x22) // "
    values.append(0x27) // '
    return Set(
      values.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }()
  static func stringLiteralDisallowed(_ scalar: Unicode.Scalar) -> Bool {
    return scalar ∈ stringLiteralDisallowedList
  }
  static func sanitize(stringLiteral: StrictString) -> StrictString {
    return stringLiteral.lazy
      .map({ ¬stringLiteralDisallowed($0) ? "\($0)" : "\u{5C}u{\($0.hexadecimalCode)}" })
      .joined()
  }
}
