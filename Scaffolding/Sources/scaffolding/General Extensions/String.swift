import Foundation

extension String {

  init(_ text: UnicodeText) {
    self.init(String.UnicodeScalarView(text))
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
    let fileData = file
    let path = baseURL.map({ url.path(relativeTo: $0) }) ?? url.path
    if let existing = try? Data(contentsOf: url),
       existing == fileData {
      reportProgress("= \(path)")
    } else {
      try fileData.save(to: url)
      reportProgress("↺ \(path)")
    }
  }
}
