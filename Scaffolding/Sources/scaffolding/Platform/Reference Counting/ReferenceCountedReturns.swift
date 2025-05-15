struct ReferenceCountedReturns {
  var all: [ReferenceCountedReturn] = []
  var unused: [String] = []
}

extension ReferenceCountedReturns {
  mutating func append(_ entry: ReferenceCountedReturn) {
    all.append(entry)
    unused.append(entry.localName)
  }
}
