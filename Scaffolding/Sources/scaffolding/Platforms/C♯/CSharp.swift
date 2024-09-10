import SDGLogic
import SDGCollections
import SDGText

enum CSharp {

  static let identifierStartList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x40) // @
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

  static func identifierAllowed(_ scalar: Unicode.Scalar) -> Bool {
    return scalar.properties.isIDContinue
      ∧ ¬scalar.isVulnerableToNormalization
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
}
