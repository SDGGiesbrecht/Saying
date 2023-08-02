import Foundation

@main struct Scaffolding {
  static func main() throws {
    let thisFile = URL(fileURLWithPath: #filePath)
    try FileManager.default.removeItem(at: thisFile)
    let packageRoot = thisFile
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
    let package = Package(location: packageRoot)
    try package.test()
  }
}
