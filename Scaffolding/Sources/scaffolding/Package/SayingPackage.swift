import Foundation

import SDGExternalProcess

struct Package {

  var location: URL

  var sourceDirectory: URL {
    return location.appendingPathComponent("Source")
  }
  static let constructionDirectoryName = ".Construction"
  var constructionDirectory: URL {
    return location.appendingPathComponent(Package.constructionDirectoryName)
  }
  static let productsDirectoryName = "Products"
  var productsDirectory: URL {
    return location.appendingPathComponent(Package.productsDirectoryName)
  }

  static let ignoredDirectories: Set<String> = [
    constructionDirectoryName,
    ".git",
    productsDirectoryName,
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

  func format(reportProgress: (String) -> Void) throws {
    for fileURL in try files() {
      let relativePath = fileURL.path(relativeTo: location)
      switch fileURL.sourceFormat {
      case .utf8(let gitStyle):
        switch gitStyle {
        case false:
          reportProgress("¬ \(relativePath)")
        case true:
          let file = try SayingSource(from: fileURL)
          let formatted = try file.formattedGitStyleSource()
          try String(formatted).appending("\n")
            .overwriteIfDifferentThan(fileURL, baseURL: location, reportProgress: reportProgress)
        }
      }
    }
  }

  func build(reportProgress: @escaping (String) -> Void) throws {
    try buildSwift(reportProgress: reportProgress)
  }

  func buildSwift(reportProgress: @escaping (String) -> Void) throws {
    try Swift.prepare(package: self, mode: .testing, reportProgress: reportProgress)
    _ = try Shell.default.run(
      command: [
        "swift", "build",
        "--package-path", Swift.preparedDirectory(for: self).path,
      ],
      reportProgress: reportProgress
    ).get()
  }

  func testC(reportProgress: @escaping (String) -> Void) throws {
    try C.prepare(package: self, mode: .testing, reportProgress: reportProgress)
    _ = try Shell.default.run(
      command: [
        "make",
        "--directory=\(C.preparedDirectory(for: self).path)",
        "test",
      ],
      reportProgress: reportProgress
    ).get()
  }

  func testSwift(reportProgress: @escaping (String) -> Void) throws {
    try Swift.prepare(package: self, mode: .testing, reportProgress: reportProgress)
    _ = try Shell.default.run(
      command: [
        "swift", "run",
        "--package-path", Swift.preparedDirectory(for: self).path,
        "test"
      ],
      reportProgress: reportProgress
    ).get()
  }

  func buildXcode(platform: String, reportProgress: @escaping (String) -> Void) throws {
    try Swift.prepare(package: self, mode: .testing, reportProgress: reportProgress)
    _ = try Shell.default.run(
      command: [
        "xcrun", "xcodebuild", "build",
        "-scheme", "Package",
        "-destination", "generic/platform=\(platform)"
      ],
      in: Swift.preparedDirectory(for: self),
      reportProgress: reportProgress
    ).get()
  }

  func testXcode(platform: String, simulator: String, reportProgress: @escaping (String) -> Void) throws {
    try buildXcode(platform: platform, reportProgress: reportProgress)
    _ = try Shell.default.run(
      command: [
        "xcrun", "xcodebuild", "test",
        "-scheme", "Package",
        "-destination", "platform=\(platform) Simulator,name=\(simulator)"
      ],
      in: Swift.preparedDirectory(for: self),
      reportProgress: reportProgress
    ).get()
  }

  func testIOS(reportProgress: @escaping (String) -> Void) throws {
    try testXcode(platform: "iOS", simulator: "iPhone 14", reportProgress: reportProgress)
  }

  func testTVOS(reportProgress: @escaping (String) -> Void) throws {
    try testXcode(platform: "tvOS", simulator: "Apple TV", reportProgress: reportProgress)
  }

  func testWatchOS(reportProgress: @escaping (String) -> Void) throws {
    try testXcode(platform: "watchOS", simulator: "Apple Watch Series 5 (40mm)", reportProgress: reportProgress)
  }
}
