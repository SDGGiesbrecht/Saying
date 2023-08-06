extension Node.Child {

  enum Kind {
    case fixed
    case required
    case optional
  }
}

extension Node.Child.Kind {

  var guaranteedNonEmpty: Bool {
    switch self {
    case .fixed, .required:
      return true
    case .optional:
      return false
    }
  }
}
