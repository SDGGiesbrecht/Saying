import Foundation

@main struct GenerateSyntax {
  static func main() throws {
    let destination = URL(fileURLWithPath: ProcessInfo.processInfo.arguments[1])
    try source().write(to: destination, atomically: true, encoding: .utf8)
  }

  static func source() -> String {
    return Node.source()
  }
}
