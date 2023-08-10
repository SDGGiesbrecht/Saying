extension Node.Child {

  enum Kind {
    case fixed
    case required
    case optional
    case array
  }
}

extension Node.Child.Kind {

  var guaranteedNonEmpty: Bool {
    switch self {
    case .fixed, .required:
      return true
    case .optional, .array:
      return false
    }
  }
}
