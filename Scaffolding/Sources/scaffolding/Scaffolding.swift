import Foundation

@main struct Scaffolding {
  static func main() throws {
    let thisFile = URL(fileURLWithPath: #filePath)
    let packageRoot = thisFile
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
    let package = Package(location: packageRoot)

    // Platforms:

    // macOS: Xcode (Swift Package Manager), Swift
    // (1976‐04‐11 Apple Computer)

    // Windows: Visual Studio (MSBuild), Windows App SDK, C#
    // (1981‐08‐12 MS‐DOS)

    // Web: HTML, JavaScript
    // (1991‐08‐06)

    // Ubuntu: GNOME Builder (Meson), GNOME, C
    // (2004‐10‐20)

    // tvOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2007‐01‐09)

    // iOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2007‐06‐29)

    // Android: from Linux, Android Studio, Kotlin
    // (2008‐09‐23)

    // Amazon Linux: MATE, Autoconf + Automake, GNU Build System, GNU Compiler Collection (gcc), C
    // (2011‐09‐26)

    // watchOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2015‐04‐24)

    let arguments = ProcessInfo.processInfo.arguments.dropFirst()
    switch arguments.first {
    case "format":
      try package.format(reportProgress: { print($0) })
    case "prepare‐c":
      try package.prepareC()
    case "prepare‐c‐sharp":
      try package.prepareCSharp()
    case "build‐javascript":
      try package.buildJavaScript()
    case "test‐c":
      try package.testC()
    case "test‐swift":
      try package.testSwift()
    case "test‐tvos":
      try package.testTVOS()
    case "test‐ios":
      try package.testIOS()
    case "test‐watchos":
      try package.testWatchOS()
    default:
      try package.test()
    }
  }
}
