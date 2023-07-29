import SDGLogic
import SDGMathematics
import SDGCollections
import SDGText

struct ParsedNonEmptySeparatedList<Entry, Separator>: ParsedSyntaxNode
where Entry: ParsedSyntaxNode, Separator: ParsedSyntaxNode {

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

extension ParsedNonEmptySeparatedList where Entry: ParsedSeparatedListEntry, Separator == ParsedToken {

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
        if tokenIndex == lastToken {
          entryBuffer.append(token)
        }
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

extension ParsedNonEmptySeparatedList {

  func processNesting(
    isOpening: (Entry) -> Bool,
    isClosing: (Entry) -> Bool
  ) -> Result<
    ParsedNonEmptySeparatedList<ParsedSeparatedNestingNode<Entry, Separator>, Separator>,
    ParsedNestingNodeParseError<Entry>
  > {

    var remainingContinuations = continuations[...]

    let newFirst: ParsedSeparatedNestingNode<Entry, Separator>
    if isOpening(first) {
      var depth = 1
      var found: Int?
      search: for index in remainingContinuations.indices {
        let continuation = remainingContinuations[index]
        if isOpening(continuation.entry) {
          depth += 1
        } else if isClosing(continuation.entry) {
          depth −= 1
          if depth == 0 {
            found = index
            break search
          }
        }
      }
      if let index = found {
        let contentContinuations = remainingContinuations[..<index]
        let closing = remainingContinuations[index]
        remainingContinuations = continuations[index...].dropFirst()
        if let firstContinuation = contentContinuations.first {
          let firstContent = firstContinuation.entry
          let contentLocation = [firstContent, contentContinuations.last!].location()!
          let groupLocation = [first, closing.entry].location()!
          newFirst = ParsedSeparatedNestingNode(
            kind: .group(
              ParsedSeparatedNestingGroup(
                opening: first,
                openingSeparator: firstContinuation.separator,
                contents: ParsedSeparatedList(
                  entries: ParsedNonEmptySeparatedList(
                    first: firstContent,
                    continuations: Array(contentContinuations.dropFirst()),
                    location: contentLocation
                  ),
                  location: contentLocation
                ),
                closingSeparator: closing.separator,
                closing: closing.entry,
                location: groupLocation
              )
            ),
            location: groupLocation
          )
        } else {
          let groupLocation = [first, closing.entry].location()!
          newFirst = ParsedSeparatedNestingNode(
            kind: .emptyGroup(
              ParsedEmptySeparatedNestingGroup(
                opening: first,
                separator: closing.separator,
                closing: closing.entry,
                location: groupLocation
              )
            ),
            location: groupLocation
          )
        }
      } else {
        return .failure(.unpairedElement(first))
      }
    } else if isClosing(first) {
      return .failure(.unpairedElement(first))
    } else {
      newFirst = ParsedSeparatedNestingNode<Entry, Separator>(kind: .leaf(first), location: first.location)
    }

    var compressedContinuations: [
      ParsedSeparatedListContinuation<ParsedSeparatedNestingNode<Entry, Separator>, Separator>
    ] = []

    while ¬remainingContinuations.isEmpty {
      let next = remainingContinuations.removeFirst()
      if isOpening(next.entry) {
        var depth = 1
        var found: Int?
        search: for index in remainingContinuations.indices {
          let continuation = remainingContinuations[index]
          if isOpening(continuation.entry) {
            depth += 1
          } else if isClosing(continuation.entry) {
            depth −= 1
            if depth == 0 {
              found = index
              break search
            }
          }
        }
        if let index = found {
          let contentContinuations = remainingContinuations[..<index]
          let closing = remainingContinuations[index]
          remainingContinuations = continuations[index...].dropFirst()
          if let firstContinuation = contentContinuations.first {
            let firstContent = firstContinuation.entry
            let contentLocation = [firstContent, contentContinuations.last!].location()!
            let groupLocation = [next.entry, closing.entry].location()!
            compressedContinuations.append(
              ParsedSeparatedListContinuation(
                separator: next.separator,
                entry: ParsedSeparatedNestingNode(
                  kind: .group(
                    ParsedSeparatedNestingGroup(
                      opening: next.entry,
                      openingSeparator: firstContinuation.separator,
                      contents: ParsedSeparatedList(
                        entries: ParsedNonEmptySeparatedList(
                          first: firstContent,
                          continuations: Array(contentContinuations.dropFirst()),
                          location: contentLocation
                        ),
                        location: contentLocation
                      ),
                      closingSeparator: closing.separator,
                      closing: closing.entry,
                      location: groupLocation
                    )
                  ),
                  location: groupLocation
                ),
                location: [next.separator, closing.entry].location()!
              )
            )
          } else {
            let groupLocation = [first, closing.entry].location()!
            compressedContinuations.append(
              ParsedSeparatedListContinuation(
                separator: next.separator,
                entry: ParsedSeparatedNestingNode(
                  kind: .emptyGroup(
                    ParsedEmptySeparatedNestingGroup(
                      opening: first,
                      separator: closing.separator,
                      closing: closing.entry,
                      location: groupLocation
                    )
                  ),
                  location: groupLocation
                ),
                location: [next.separator, closing.entry].location()!
              )
            )
          }
        } else {
          return .failure(.unpairedElement(first))
        }
      } else if isClosing(next.entry) {
        return .failure(.unpairedElement(first))
      } else {
        compressedContinuations.append(
          ParsedSeparatedListContinuation(
            separator: next.separator,
            entry: ParsedSeparatedNestingNode(
              kind: .leaf(next.entry),
              location: next.entry.location
            ),
            location: next.location
          )
        )
      }
    }

    return .success(
      ParsedNonEmptySeparatedList<ParsedSeparatedNestingNode, Separator>(
        first: newFirst,
        continuations: compressedContinuations,
        location: location)
    )
  }
}
