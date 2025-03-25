enum AccessIntermediate: Comparable {
  case nowhere
  static var inferred: AccessIntermediate { .file }
  case file
  case unit
  case clients
}

extension AccessIntermediate {
  init(_ declaration: ParsedAccessDeclaration?) {
    if let keyword = declaration {
      switch keyword {
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
  init(_ declaration: ParsedWriteAccessDeclaration) {
    switch declaration {
    case .general(let access):
      self = AccessIntermediate(access)
    case .nowhere:
      self = .nowhere
    }
  }
  init(_ accessNode: ParsedAccess?) {
    self = AccessIntermediate(accessNode?.keyword)
  }
  init(readAccessFrom declaration: ParsedStorageAccessDeclaration?) {
    if let keywords = declaration {
      switch keywords {
      case .differing(let differing):
        self = AccessIntermediate(differing.read)
      case .same(let same):
        self = AccessIntermediate(same)
      }
    } else {
      self = .inferred
    }
  }
  init(writeAccessFrom declaration: ParsedStorageAccessDeclaration?) {
    if let keywords = declaration {
      switch keywords {
      case .differing(let differing):
        self = AccessIntermediate(differing.write)
      case .same(let same):
        self = AccessIntermediate(same)
      }
    } else {
      self = .inferred
    }
  }
}
