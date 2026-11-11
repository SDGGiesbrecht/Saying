import Foundation

import Saying

extension GitStyleSayingSource {

  init(from url: URL, packageURL: URL) throws {
    self.init(origin: UnicodeText(url.path(relativeTo: packageURL)), code: UnicodeText(try String(contentsOf: url, encoding: .utf8)))
  }
}
