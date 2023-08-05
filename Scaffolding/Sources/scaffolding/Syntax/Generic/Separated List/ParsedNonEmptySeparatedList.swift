import SDGLogic
import SDGMathematics
import SDGCollections
import SDGText

struct ParsedNonEmptySeparatedList<Entry, Separator>
where Entry: ManualParsedSyntaxNode, Separator: ManualParsedSyntaxNode {

  init(
    first: Entry,
    continuations: [ParsedSeparatedListContinuation<Entry, Separator>]
  ) {
    self.first = first
    self.continuations = continuations
  }

  let first: Entry
  let continuations: [ParsedSeparatedListContinuation<Entry, Separator>]

  var combinedEntries: [Entry] {
    var entries = [first]
    entries.append(contentsOf: continuations.lazy.map({ $0.entry }))
    return entries
  }
}

extension ParsedNonEmptySeparatedList: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    var result: [ManualParsedSyntaxNode] = [first]
    result.append(contentsOf: continuations)
    return result
  }
}

extension ParsedNonEmptySeparatedList: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return first
  }
  var lastChild: ManualParsedSyntaxNode {
    return continuations.last ?? first
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
      defer { cursor = token.endIndex }
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
                entry: entry
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
        continuations: continuations
      )
    )
  }
}

extension ParsedNonEmptySeparatedList {

  func map<NewEntry, Error>(
    _ closure: (Entry) -> Result<NewEntry, Error>
  ) -> Result<ParsedNonEmptySeparatedList<NewEntry, Separator>, Error> {
    switch closure(first) {
    case .failure(let error):
      return .failure(error)
    case .success(let newFirst):
      var newContinuations: [ParsedSeparatedListContinuation<NewEntry, Separator>] = []
      newContinuations.reserveCapacity(continuations.count)
      for continuation in continuations {
        switch continuation.map(closure) {
        case .failure(let error):
          return .failure(error)
        case .success(let new):
          newContinuations.append(new)
        }
      }
      return .success(
        ParsedNonEmptySeparatedList<NewEntry, Separator>(
          first: newFirst,
          continuations: newContinuations
        )
      )
    }
  }

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
          newFirst = .group(
            ParsedSeparatedNestingGroup(
              opening: first,
              openingSeparator: firstContinuation.separator,
              contents: ParsedSeparatedList(
                entries: ParsedNonEmptySeparatedList(
                  first: firstContent,
                  continuations: Array(contentContinuations.dropFirst())
                ),
                location: [firstContent, contentContinuations.last!].location()!
              ),
              closingSeparator: closing.separator,
              closing: closing.entry
            )
          )
        } else {
          newFirst = .emptyGroup(
            ParsedEmptySeparatedNestingGroup(
              opening: first,
              separator: closing.separator,
              closing: closing.entry
            )
          )
        }
      } else {
        return .failure(.unpairedElement(first))
      }
    } else if isClosing(first) {
      return .failure(.unpairedElement(first))
    } else {
      newFirst = .leaf(first)
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
            compressedContinuations.append(
              ParsedSeparatedListContinuation(
                separator: next.separator,
                entry: .group(
                  ParsedSeparatedNestingGroup(
                    opening: next.entry,
                    openingSeparator: firstContinuation.separator,
                    contents: ParsedSeparatedList(
                      entries: ParsedNonEmptySeparatedList(
                        first: firstContent,
                        continuations: Array(contentContinuations.dropFirst())
                      ),
                      location: [firstContent, contentContinuations.last!].location()!
                    ),
                    closingSeparator: closing.separator,
                    closing: closing.entry
                  )
                )
              )
            )
          } else {
            compressedContinuations.append(
              ParsedSeparatedListContinuation(
                separator: next.separator,
                entry: .emptyGroup(
                  ParsedEmptySeparatedNestingGroup(
                    opening: first,
                    separator: closing.separator,
                    closing: closing.entry
                  )
                )
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
            entry: .leaf(next.entry)
          )
        )
      }
    }

    return .success(
      ParsedNonEmptySeparatedList<ParsedSeparatedNestingNode, Separator>(
        first: newFirst,
        continuations: compressedContinuations
      )
    )
  }
}
