struct ReferenceCountedReturns {
  var all: [ReferenceCountedReturn] = []
  var unused: [String] = []
}

extension ReferenceCountedReturns {
  mutating func append(_ entry: ReferenceCountedReturn) {
    all.append(entry)
    unused.append(entry.localName)
  }

  mutating func append(contentsOf entries: ReferenceCountedReturns) {
    all.append(contentsOf: entries.all)
    unused.append(contentsOf: entries.unused)
  }
}
