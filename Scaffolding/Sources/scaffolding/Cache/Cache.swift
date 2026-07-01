import Foundation

struct Cache {
  fileprivate let location: URL
  fileprivate let reportProgress: (String) -> Void
  fileprivate var updated: Set<[String]> = []
  fileprivate var ignoredDirectories: Set<[String]>

  init(
    location: URL,
    reportProgress: @escaping (String) -> Void,
    ignoredSubdirectories: Set<[String]>
  ) {
    self.location = location
    self.reportProgress = reportProgress
    self.ignoredDirectories = ignoredSubdirectories
  }
}

extension Cache {

  fileprivate func url(of relativePath: [String]) -> URL {
    var result = location
    for component in relativePath {
      result = result.appendingPathComponent(component)
    }
    return result
  }

  func files() throws -> [[String]] {
    return try FileManager.default.deepFileEnumeration(in: location)
      .lazy.map({ $0.path(relativeTo: location).components(separatedBy: "/") as [String] })
      .sorted(by: { $0.lexicographicallyPrecedes($1) })
  }
}

extension Cache {

  mutating func update(_ relativePath: [String], to file: String) throws {
    let location = url(of: relativePath)
    if !updated.insert(relativePath).inserted {
      print("Inefficient double write: \(location.path)")
    }
    try file.overwriteIfDifferentThan(location, baseURL: self.location, reportProgress: reportProgress)
  }

  mutating func removeStale() throws {
    eachFile: for relativePath in try files() {
      if let lastPathComponent = relativePath.last,
        Package.ignoredFiles.contains(lastPathComponent) {
        continue
      }
      for ignored in ignoredDirectories {
        if relativePath.hasPrefix(ignored) {
          continue eachFile
        }
      }

      if updated.contains(relativePath) {
        continue
      }
      let url = self.url(of: relativePath)
      try FileManager.default.removeItem(at: url)
      reportProgress("✗ \(url.path(relativeTo: location))")
      updated.insert(relativePath)
    }
  }
}
