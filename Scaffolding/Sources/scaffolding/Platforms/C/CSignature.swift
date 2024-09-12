import SDGText

struct CSignature: Hashable, Comparable {
  let parameters: [StrictString]
  let returnValue: StrictString

  static func < (lhs: CSignature, rhs: CSignature) -> Bool {
    if lhs.parameters.lexicographicallyPrecedes(rhs.parameters) {
      return true
    } else if lhs.parameters == rhs.parameters {
      return lhs.returnValue < rhs.returnValue
    } else {
      return false
    }
  }
}
