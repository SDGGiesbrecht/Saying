import Foundation

extension SayingSource {

  init(from url: URL) throws {
    let origin = UnicodeText(url.path)
    switch url.sourceFormat {
    case .utf8(let gitStyle):
      switch gitStyle {
      case false:
        self.init(origin: origin, code: .utf8(try UTF8File(from: url).source))
      case true:
        self.init(origin: origin, code: .utf8(try UTF8File(gitStyle: GitStyleFile(from: url)).source))
      }
    }
  }

  func parse() throws -> ParsedDeclarationList {
    switch code {
    case .utf8(let source):
      return try ParsedDeclarationList.fastParse(source: source, origin: origin)
        ?? ParsedDeclarationList.diagnosticParse(source: source, origin: origin).get()
    }
  }

  func formattedGitStyleSource() throws -> UnicodeText {
    return try parse().formattedGitStyleSource()
  }
}

func compilerGeneratedOrigin(file: StaticString = #filePath, line: UInt = #line) -> UnicodeText {
  return "\(file) (\(line))"
}
