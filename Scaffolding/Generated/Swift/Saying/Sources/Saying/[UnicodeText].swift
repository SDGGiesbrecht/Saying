extension [UnicodeText] {
  public func joinedAccordingToDefaultUseAsStringableList(separator: UnicodeText) -> UnicodeText {
    var string: UnicodeText = .empty
    var first: Bool = true
    for segment in self {
      if !first {
        string.append(contentsOf: separator)
      }
      string.append(contentsOf: segment)
      first = false
    }
    return string
  }
}

extension [UnicodeText] {
  public func joined(separator: UnicodeText) -> UnicodeText {
    return self.joinedAccordingToDefaultUseAsStringableList(separator: separator)
  }
}

extension [UnicodeText] {
  public func joinedAccordingToDefaultUseAsStringableList() -> UnicodeText {
    var string: UnicodeText = .empty
    for segment in self {
      string.append(contentsOf: segment)
    }
    return string
  }
}

extension [UnicodeText] {
  public func joined() -> UnicodeText {
    return self.joinedAccordingToDefaultUseAsStringableList()
  }
}
