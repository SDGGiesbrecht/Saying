extension [Set<UnicodeText>] {
  public func appendingAccordingToDefaultUseAsChangeableList(_ newElement: Set<UnicodeText>) -> [Set<UnicodeText>] {
    var copy: [Set<UnicodeText>] = self
    copy.append(newElement)
    return copy
  }
}

extension [Set<UnicodeText>] {
  public func appending(_ newElement: Set<UnicodeText>) -> [Set<UnicodeText>] {
    return self.appendingAccordingToDefaultUseAsChangeableList(newElement)
  }
}
