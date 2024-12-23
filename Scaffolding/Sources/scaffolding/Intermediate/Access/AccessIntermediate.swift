enum AccessIntermediate: Comparable {
  static var inferred: AccessIntermediate { .file }
  case file
  case clients
}

extension AccessIntermediate {
  init(_ accessNode: ParsedAccess?) {
    if let node = accessNode {
      switch node.keyword {
      case .file:
        self = .file
      case .clients:
        self = .clients
      }
    } else {
      self = .inferred
    }
  }
}
