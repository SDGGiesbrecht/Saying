struct NativeActionNamesIntermediate {
  var kotlin: UnicodeText?
  var swift: UnicodeText?

  init(
    kotlin: UnicodeText?,
    swift: UnicodeText?
  ) {
    self.kotlin = kotlin
    self.swift = swift
  }
}

extension NativeActionNamesIntermediate {
  static var none: NativeActionNamesIntermediate {
    return NativeActionNamesIntermediate(
      kotlin: nil,
      swift: nil
    )
  }
}

extension NativeActionNamesIntermediate {
  func merging(
    requirement: NativeActionNamesIntermediate
  ) -> NativeActionNamesIntermediate {
    return NativeActionNamesIntermediate(
      kotlin: kotlin ?? requirement.kotlin,
      swift: swift ?? requirement.swift
    )
  }
}
