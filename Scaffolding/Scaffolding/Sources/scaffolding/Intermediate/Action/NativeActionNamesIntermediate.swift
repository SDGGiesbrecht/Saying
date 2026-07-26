struct NativeActionNamesIntermediate {
  var c: UnicodeText?
  var cSharp: UnicodeText?
  var kotlin: UnicodeText?
  var swift: UnicodeText?

  init(
    c: UnicodeText?,
    cSharp: UnicodeText?,
    kotlin: UnicodeText?,
    swift: UnicodeText?
  ) {
    self.c = c
    self.cSharp = cSharp
    self.kotlin = kotlin
    self.swift = swift
  }
}

extension NativeActionNamesIntermediate {
  static var none: NativeActionNamesIntermediate {
    return NativeActionNamesIntermediate(
      c: nil,
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
      c: c ?? requirement.c,
      cSharp: cSharp ?? requirement.cSharp,
      kotlin: kotlin ?? requirement.kotlin,
      swift: swift ?? requirement.swift
    )
  }
}
