import SDGLogic
import SDGCollections

struct ParsedNonEmptySeparatedList<Entry, Separator>: ParsedSyntaxNode
where Entry: ParsedSyntaxNode, Separator: ParsedSyntaxNode,
  Entry: ParsedSeparatedListEntry {

  init(
    first: Entry,
    continuations: [ParsedSeparatedListContinuation<Entry, Separator>],
    location: Slice<UTF8Segments>
  ) {
    self.first = first
    self.continuations = continuations
    self.location = location
  }

  let first: Entry
  let continuations: [ParsedSeparatedListContinuation<Entry, Separator>]
  let location: Slice<UTF8Segments>

  var combinedEntries: [Entry] {
    var entries = [first]
    entries.append(contentsOf: continuations.lazy.map({ $0.entry }))
    return entries
  }
}

extension ParsedNonEmptySeparatedList where Separator == ParsedToken {

  static func parse(
    source: [ParsedToken],
    location: Slice<UTF8Segments>,
    isSeparator: (ParsedToken) -> Bool
  ) -> Result<Self, Self.ParseError> {
    var firstEntry: Entry? = nil
    var continuations: [ParsedSeparatedListContinuation<Entry, Separator>] = []
    var entryBuffer: [ParsedToken] = []
    var separatorBuffer: Separator? = nil
    var cursor: UTF8Segments.Index = location.startIndex
    let lastToken = source.indices.last
    for tokenIndex in source.indices {
      let token = source[tokenIndex]
      defer { cursor = token.location.endIndex }
      let foundSeparator = isSeparator(token)
      if foundSeparator ∨ tokenIndex == lastToken {
        defer { entryBuffer.removeAll(keepingCapacity: true) }
        switch Entry.parse(
          source: entryBuffer,
          location: entryBuffer.location() ?? location.base.emptySubSequence(at: cursor)
        ) {
        case .failure(let error):
          return .failure(.brokenEntry(error))
        case .success(let entry):
          if firstEntry == nil {
            firstEntry = entry
          } else {
            let separator = separatorBuffer!
            continuations.append(
              ParsedSeparatedListContinuation(
                separator: separator,
                entry: entry,
                location: [separator, entry].location()!
              )
            )
          }
        }
      }
      if foundSeparator {
        separatorBuffer = token
      } else {
        entryBuffer.append(token)
      }
    }
    guard let first = firstEntry else {
      return .failure(.empty)
    }
    return .success(
      ParsedNonEmptySeparatedList(
        first: first,
        continuations: continuations,
        location: source.location()!
      )
    )
  }
}
