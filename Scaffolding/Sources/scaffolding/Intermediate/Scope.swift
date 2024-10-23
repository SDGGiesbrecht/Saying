import SDGText

protocol Scope {
  func lookupAction(
    _ identifier: StrictString,
    signature: [StrictString],
    specifiedReturnValue: StrictString??
  ) -> ActionIntermediate?
}

extension Array where Element == Scope {

  func lookupAction(
    _ identifier: StrictString,
    signature: [StrictString],
    specifiedReturnValue: StrictString??
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
