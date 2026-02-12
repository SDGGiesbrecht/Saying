struct ReferencePassingExtractions {
  var all: [ReferencePassingExtraction] = []
  var unused: [String] = []
}

extension ReferencePassingExtractions {
  mutating func append(_ entry: ReferencePassingExtraction) {
    all.append(entry)
    unused.append(entry.localName)
  }

  mutating func append(contentsOf entries: ReferencePassingExtractions) {
    all.append(contentsOf: entries.all)
    unused.append(contentsOf: entries.unused)
  }
}
