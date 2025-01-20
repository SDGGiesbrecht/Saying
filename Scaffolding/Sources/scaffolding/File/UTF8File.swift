import Foundation

import SDGText

struct UTF8File {

  init(source: UnicodeText) {
    self.source = UTF8Segments(source)
  }

  init(from url: URL) throws {
    self.init(source: UnicodeText(try StrictString(from: url)))
  }

  init(gitStyle: GitStyleFile) {
    source = gitStyle.parsed()
  }

  let source: UTF8Segments
}
