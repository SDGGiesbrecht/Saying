import Foundation

import SDGPersistence

extension String {

  init<Number>(hexadecimal number: Number) where Number: BinaryInteger {
    self.init(number, radix: 16, uppercase: true)
  }

  func overrwite(_ url: URL) throws {
    try save(to: url)
    print("Updated: \(url.lastPathComponent) (\(url.path))")
  }
}
