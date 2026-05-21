import Foundation

import SDGPersistence

extension FileConvertible {

  func overwriteIfDifferentThan(_ url: URL, baseURL: URL?, reportProgress: (String) -> Void) throws {
    let fileData = file
    let path = baseURL.map({ url.path(relativeTo: $0) }) ?? url.path
    if let existing = try? Data(from: url),
      existing == fileData {
      reportProgress("= \(path)")
    } else {
      try fileData.save(to: url)
      reportProgress("↺ \(path)")
    }
  }
}
