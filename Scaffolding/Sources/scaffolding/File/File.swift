import Foundation

import SDGText

struct File {

  init(from url: URL) throws {
    self.url = url
    switch url.sourceFormat {
    case .utf8(let gitStyle):
      switch gitStyle {
      case false:
        contents = .utf8(try UTF8File(from: url).source)
      case true:
        contents = .utf8(try UTF8File(gitStyle: GitStyleFile(from: url)).source)
      }
    }
  }

  let url: URL
  let contents: Source

  func parse() throws -> ParsedDeclarationList {
    switch contents {
    case .utf8(let source):
      return try ParsedDeclarationList.fastParse(source: source)
        ?? ParsedDeclarationList.diagnosticParse(source: source).get()
    }
  }

  func formattedGitStyleSource() throws -> StrictString {
    return try parse().formattedGitStyleSource()
  }
}
