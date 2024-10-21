import SDGText

protocol Scope {
  func lookupAction(_ identifier: StrictString) -> ActionIntermediate?
}

extension Array where Element == Scope {

  func lookupAction(_ identifier: StrictString) -> ActionIntermediate? {
    for scope in reversed() {
      if let found = scope.lookupAction(identifier) {
        return found
      }
    }
    return nil
  }
}
