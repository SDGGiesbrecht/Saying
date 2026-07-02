import Foundation

extension String {

  init<Number>(hexadecimal number: Number) where Number: BinaryInteger {
    self.init(number, radix: 16, uppercase: true)
  }

  func overwrite(_ url: URL) throws {
    try write(to: url, atomically: true, encoding: .utf8)
    print("Updated: \(url.lastPathComponent) (\(url.path))")
  }
}
