struct TestContext {
  var isHidden: Bool
  var inheritedVisibility: AccessIntermediate
}

extension TestContext {
  static func inherited(visibility: AccessIntermediate, isTestOnly: Bool) -> TestContext? {
    return isTestOnly ? TestContext(isHidden: true, inheritedVisibility: visibility) : nil
  }
}

extension Optional where Wrapped == TestContext {
  func validateAccess(
    to access: AccessIntermediate,
    testOnly: Bool,
    errors: inout [ReferenceError],
    unavailableOutsideTestsError: () -> ReferenceError,
    unavailableInVisibleTestsError: () -> ReferenceError
  ) {
    if let test = self {
      if !test.isHidden,
         access < test.inheritedVisibility {
        errors.append(unavailableInVisibleTestsError())
      }
    } else {
      if testOnly {
        errors.append(unavailableOutsideTestsError())
      }
    }
  }
}
