extension [Unicode_0020segment] {
  func entryIndex(afterBoundary boundary: Int) -> Int? {
    if boundary < self.endIndex {
      return boundary
    }
    return nil
  }
}

extension [Unicode_0020segment] {
  func indexSkippingBoundsCheck(beforeBoundary boundary: Int) -> Int {
    return self.index(before: boundary)
  }
}

extension [Unicode_0020segment] {
  func entryIndex(beforeBoundary boundary: Int) -> Int? {
    if boundary > self.startIndex {
      return self.indexSkippingBoundsCheck(beforeBoundary: boundary)
    }
    return nil
  }
}

extension [Unicode_0020segment] {
  mutating func removeLastAccordingToDefaultUseAsChangeableList() {
    if let last = self.entryIndex(beforeBoundary: self.endIndex) {
      self.remove(at: last)
    }
  }
}

extension [Unicode_0020segment] {
  mutating func removeLast() {
    self.removeLastAccordingToDefaultUseAsChangeableList()
  }
}
