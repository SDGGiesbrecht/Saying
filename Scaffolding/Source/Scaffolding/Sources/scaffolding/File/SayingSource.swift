import Foundation

import Saying

extension SayingSource {

  init(from url: URL, packageURL: URL) throws {
    switch url.sourceFormat {
    case .utf8(let gitStyle):
      switch gitStyle {
      case false:
        self.init(
          origin: UnicodeText(url.path(relativeTo: packageURL)),
          code: .utf8(UnicodeSegments(allOf: UnicodeText(try String(contentsOf: url, encoding: .utf8))))
        )
      case true:
        self = try GitStyleSayingSource(from: url, packageURL: packageURL).parsed()
      }
    }
  }

  func parse() throws -> ParsedDeclarationList {
    switch code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let source):
      return try ParsedDeclarationList.fastParse(source: source, origin: origin)
        ?? ParsedDeclarationList.diagnosticParse(source: source, origin: origin).get()
    }
  }

  func formattedGitStyleSource() throws -> UnicodeText {
    return try parse().formattedGitStyleSource()
  }
}

private let repositoryRoot: URL = {
  let thisFile = #filePath
  let expected = "Scaffolding/Source/Scaffolding/Sources/scaffolding/File/SayingSource.swift"
  var url = URL(fileURLWithPath: thisFile)
  for _ in 0 ..< expected.lazy.filter({ $0 == "/" }).count + 1 {
    url.deleteLastPathComponent()
  }
  assert(URL(fileURLWithPath: thisFile).path(relativeTo: url) == expected, "Package root determination is broken because this file is in unexpected location: \(URL(fileURLWithPath: thisFile).path(relativeTo: url)) ≠ \(expected)")
  return url
}()
func compilerGeneratedOrigin(file: String = #filePath, line: UInt = #line) -> UnicodeText {
  return "\(URL(fileURLWithPath: file).path(relativeTo: repositoryRoot)) (\(line))"
}
