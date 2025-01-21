enum AccessIntermediate: Comparable {
  static var inferred: AccessIntermediate { .file }
  case file
  case unit
  case clients
}

extension AccessIntermediate {
  init(_ accessNode: ParsedAccess?) {
    if let node = accessNode {
      switch node.keyword {
      case .file:
        self = .file
      case .unit:
        self = .unit
      case .clients:
        self = .clients
      }
    } else {
      self = .inferred
    }
  }
}
