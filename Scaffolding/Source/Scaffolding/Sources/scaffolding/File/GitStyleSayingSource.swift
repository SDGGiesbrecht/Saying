import Foundation

import Saying

extension GitStyleSayingSource {

  init(from url: URL) throws {
    self.init(origin: UnicodeText(url.path), code: UnicodeText(try String(contentsOf: url, encoding: .utf8)))
  }
}
