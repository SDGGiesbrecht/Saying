import Foundation

@main struct Scaffolding {
  static func main() throws {
    let thisFile = URL(fileURLWithPath: #filePath)
    let packageRoot = thisFile
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
    let package = Package(location: packageRoot)

    let arguments = ProcessInfo.processInfo.arguments.dropFirst()
    switch arguments.first {
    case "format":
      try package.format(reportProgress: { print($0) })
    case "test‐swift":
      try package.testSwift()
    case "test‐ios":
      try package.testIOS()
    default:
      try package.test()
    }
  }
}
