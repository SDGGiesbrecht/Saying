import SDGText

protocol Scope {
  func lookupAction(
    _ identifier: StrictString,
    signature: [TypeReference],
    specifiedReturnValue: TypeReference??
  ) -> ActionIntermediate?
}

extension Array where Element == Scope {

  func lookupAction(
    _ identifier: StrictString,
    signature: [TypeReference],
    specifiedReturnValue: TypeReference??
  ) -> ActionIntermediate? {
    for scope in reversed() {
      if let found = scope.lookupAction(
        identifier,
        signature: signature,
        specifiedReturnValue: specifiedReturnValue
      ) {
        return found
      }
    }
    return nil
  }
}
