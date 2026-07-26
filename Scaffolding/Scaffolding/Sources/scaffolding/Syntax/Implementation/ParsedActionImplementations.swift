extension ParsedActionImplementations {

  var source: ParsedSourceOrCreationActionImplementation? {
    switch self {
    case .source(let source):
      return source
    case .dual(let dual):
      return dual.source
    case .native:
      return nil
    }
  }

  var native: ParsedNativeActionImplementations? {
    switch self {
    case .source:
      return nil
    case .dual(let dual):
      return dual.native
    case .native(let native):
      return native
    }
  }
}
