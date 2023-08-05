extension Node.Child {

  enum Kind {
    case required
    case optional
  }
}

extension Node.Child.Kind {

  var guaranteedNonEmpty: Bool {
    switch self {
    case .required:
      return true
    case .optional:
      return false
    }
  }
}
