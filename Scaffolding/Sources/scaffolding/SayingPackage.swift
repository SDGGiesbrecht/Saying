import Foundation

import SDGCollections
import SDGPersistence

struct SayingPackage {

  var location: URL

  var sourceDirectory: URL {
    return location.appendingPathComponent("Source")
  }

  let ignoredFiles: Set<String> = [".DS_Store"]

  func modules() throws -> [Module] {
    return try FileManager.default.contents(ofDirectory: sourceDirectory)
      .lazy.filter({ $0.lastPathComponent ∉ ignoredFiles })
      .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
      .map({ Module(directory: $0)})
  }

  func test() throws {
    let modules = try self.modules()
    for module in modules {
      print(module.directory.lastPathComponent)
    }
  }
}
