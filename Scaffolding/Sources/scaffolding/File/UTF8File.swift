import Foundation

import SDGText

struct UTF8File {

  init(source: StrictString) {
    self.source = UTF8Segments([UTF8Segment(offset: 0, source: source)])
  }

  init(from url: URL) throws {
    self.init(source: try StrictString(from: url))
  }

  init(gitStyle: GitStyleFile) {
    source = gitStyle.parsed()
  }

  let source: UTF8Segments
}
