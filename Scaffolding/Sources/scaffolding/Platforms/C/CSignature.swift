import SDGText

struct CSignature: Hashable, Comparable {
  let parameters: [StrictString]
  let returnValue: StrictString
  let boolLiteral: Bool
  let equals: Bool
  let and: Bool
  let assert: Bool

  static func < (lhs: CSignature, rhs: CSignature) -> Bool {
    if lhs.parameters.lexicographicallyPrecedes(rhs.parameters) {
      return true
    } else if lhs.parameters == rhs.parameters {
      return lhs.returnValue < rhs.returnValue
    } else {
      return false
    }
  }

  func registerAndExecuteName() -> String {
    if boolLiteral {
      return "register_and_execute_bool_literal"
    } else if equals {
      return "register_and_execute_equals"
    } else if and {
      return "register_and_execute_and"
    } else if assert {
      return "register_and_execute_assert"
    } else {
      let disambiguator: StrictString = "\(parameters.joined(separator: ", ")) → \(returnValue)"
      let sanitizedDisambiguator = C.sanitize(identifier: disambiguator, leading: false)
      return "register_and_execute_\(sanitizedDisambiguator)"
    }
  }
}
