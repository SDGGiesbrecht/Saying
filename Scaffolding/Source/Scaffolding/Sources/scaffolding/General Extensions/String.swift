import Foundation

import Saying

extension String {

  init(_ text: UnicodeText) {
    self.init(String.UnicodeScalarView(text))
  }

  init(_ text: UnicodeText.SubSequence) {
    self.init(String.UnicodeScalarView(text))
  }

  func prefix(upTo searchTerm: String) -> String.SubSequence? {
    guard let index = indices.first(where: { self[$0...].starts(with: searchTerm) }) else {
      return nil
    }
    return self[..<index]
  }

  func dropping(through searchTerm: String) -> String.SubSequence {
    guard let index = indices.first(where: { self[$0...].starts(with: searchTerm) }) else {
      return self[...]
    }
    return self[index...].dropFirst(searchTerm.count)
  }

  mutating func prepend(contentsOf prependix: String) {
    self = prependix + self
  }
}

func compute(_ compute: () -> String, cachingIn cache: inout String?) -> String {
  if let cached = cache {
    return cached
  }
  let result: String = compute()
  cache = result
  return result
}

extension String {

  func overwriteIfDifferentThan(_ url: URL, baseURL: URL?, reportProgress: (String) -> Void) throws {
    let fileData = data(using: .utf8)!
    let path = baseURL.map({ url.path(relativeTo: $0) }) ?? url.path
    if let existing = try? Data(contentsOf: url),
       existing == fileData {
      reportProgress("= \(path)")
    } else {
      let directory = url.deletingLastPathComponent()
      try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
      try fileData.write(to: url, options: [.atomic])
      reportProgress("↺ \(path)")
    }
  }
}
