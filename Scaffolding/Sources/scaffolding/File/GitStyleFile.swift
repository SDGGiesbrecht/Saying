import Foundation

import SDGText
import SDGPersistence

struct GitStyleFile {

  init(source: StrictString) {
    self.source = source
  }

  init(from url: URL) throws {
    self.init(source: try StrictString(from: url))
  }

  let source: StrictString

  func parsed() -> StrictString {
    var result = source
    if result.last == "\n" {
      result.removeLast()
    }
    return result
      .components(separatedBy: "\n")
      .lazy.map({ line in
        var string = StrictString(line.contents)
        while string.first == " " {
          string.removeFirst()
        }
        return StrictString(string)
      })
      .joined(separator: "\u{2028}")
      .replacingMatches(for: "\u{2028}", with: "\u{2029}")
  }
}
