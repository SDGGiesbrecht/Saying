extension Collection {

  func emptySubSequence(at index: Index) -> SubSequence {
    return self[index..<index]
  }
}
