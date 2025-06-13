import Foundation

import SDGText
import SDGPersistence
import SDGExternalProcess

struct Package {

  var location: URL

  var sourceDirectory: URL {
    return location.appendingPathComponent("Source")
  }
  var constructionDirectory: URL {
    return location.appendingPathComponent(".Construction")
  }
  var productsDirectory: URL {
    return location.appendingPathComponent("Products")
  }

  static let ignoredDirectories: Set<String> = [
    ".git"
  ]
  static let ignoredFiles: Set<String> = [
    ".DS_Store",
  ]

  func modules() throws -> [Module] {
    return try FileManager.default.contents(ofDirectory: sourceDirectory)
      .lazy.filter({ !Package.ignoredFiles.contains($0.lastPathComponent) })
      .lazy.filter({ $0.hasDirectoryPath == true })
      .lazy.filter({ url in
        return try FileManager.default.deepFileEnumeration(in: url)
          .contains(where: { $0.isSaying })
      })
      .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
      .map({ Module(directory: $0)})
  }

  func files() throws -> [URL] {
    return try FileManager.default.deepFileEnumeration(in: location)
      .lazy.filter({ !Package.ignoredDirectories.contains($0.path(relativeTo: location).truncated(before: "/")) })
      .lazy.filter({ !Package.ignoredFiles.contains($0.lastPathComponent) })
      .sorted(by: { $0.path < $1.path })
  }

  func format(reportProgress: (UnicodeText) -> Void) throws {
    for fileURL in try files() {
      let relativePath = fileURL.path(relativeTo: location)
      switch fileURL.sourceFormat {
      case .utf8(let gitStyle):
        switch gitStyle {
        case false:
          reportProgress(UnicodeText("¬\(relativePath)"))
        case true:
          reportProgress(UnicodeText(" \(relativePath)"))
          let file = try SayingSource(from: fileURL)
          let formatted = try file.formattedGitStyleSource()
          try StrictString(formatted).appending("\n").save(to: fileURL)
        }
      }
    }
  }

  func build() throws {
    try buildSwift()
  }

  func buildSwift() throws {
    try Swift.prepare(package: self, mode: .testing)
    _ = try Shell.default.run(
      command: [
        "swift", "build",
        "--package-path", Swift.preparedDirectory(for: self).path,
      ],
      reportProgress: { print($0) }
    ).get()
  }

  func testC() throws {
    try C.prepare(package: self, mode: .testing)
    let directory = C.preparedDirectory(for: self)
    _ = try Shell.default.run(
      command: [
        "cc",
        directory.appendingPathComponent("test.c").path,
        "-o", directory.appendingPathComponent("test").path,
      ],
      reportProgress: { print($0) }
    ).get()
    _ = try Shell.default.run(
      command: [
        directory.appendingPathComponent("test").path
      ],
      reportProgress: { print($0) }
    ).get()
  }

  func testSwift() throws {
    try Swift.prepare(package: self, mode: .testing)
    _ = try Shell.default.run(
      command: [
        "swift", "run",
        "--package-path", Swift.preparedDirectory(for: self).path,
        "test"
      ],
      reportProgress: { print($0) }
    ).get()
  }

  func buildXcode(platform: String) throws {
    try Swift.prepare(package: self, mode: .testing)
    _ = try Shell.default.run(
      command: [
        "xcrun", "xcodebuild", "build",
        "-scheme", "Package",
        "-destination", "generic/platform=\(platform)"
      ],
      in: Swift.preparedDirectory(for: self),
      reportProgress: { print($0) }
    ).get()
  }

  func testXcode(platform: String, simulator: String) throws {
    try buildXcode(platform: platform)
    _ = try Shell.default.run(
      command: [
        "xcrun", "xcodebuild", "test",
        "-scheme", "Package",
        "-destination", "platform=\(platform) Simulator,name=\(simulator)"
      ],
      in: Swift.preparedDirectory(for: self),
      reportProgress: { print($0) }
    ).get()
  }

  func testIOS() throws {
    try testXcode(platform: "iOS", simulator: "iPhone 14")
  }

  func testTVOS() throws {
    try testXcode(platform: "tvOS", simulator: "Apple TV")
  }

  func testWatchOS() throws {
    try testXcode(platform: "watchOS", simulator: "Apple Watch Series 5 (40mm)")
  }
}
