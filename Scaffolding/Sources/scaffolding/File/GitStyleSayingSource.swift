import Foundation

extension GitStyleSayingSource {

  init(from url: URL) throws {
    self.init(origin: UnicodeText(url.path), code: UnicodeText(try String(from: url)))
  }
}
