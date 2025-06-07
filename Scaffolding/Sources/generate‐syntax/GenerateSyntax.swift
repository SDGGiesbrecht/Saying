import Foundation

import SDGPersistence

@main struct GenerateSyntax {
  static func main() throws {
    let destination = URL(fileURLWithPath: ProcessInfo.processInfo.arguments[1])
    try source().save(to: destination)
  }

  static func source() -> String {
    return Node.source()
  }
}
