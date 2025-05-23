struct NativeActionNamesIntermediate {
  var cSharp: UnicodeText?
  var kotlin: UnicodeText?
  var swift: UnicodeText?

  init(
    cSharp: UnicodeText?,
    kotlin: UnicodeText?,
    swift: UnicodeText?
  ) {
    self.cSharp = cSharp
    self.kotlin = kotlin
    self.swift = swift
  }
}

extension NativeActionNamesIntermediate {
  static var none: NativeActionNamesIntermediate {
    return NativeActionNamesIntermediate(
      cSharp: nil,
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
      cSharp: cSharp ?? requirement.cSharp,
      kotlin: kotlin ?? requirement.kotlin,
      swift: swift ?? requirement.swift
    )
  }
}
