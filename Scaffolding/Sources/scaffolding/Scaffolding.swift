import Foundation

@main struct Scaffolding {
  static func main() {
    do {
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

      // Android: from Linux, Android Studio (Gradle), Kotlin
      // (2008‐09‐23)

      // Amazon Linux: MATE, Developer Tools (GNU Compiler Collection (gcc)), C
      // (2011‐09‐26)

      // watchOS: from macOS, Xcode (Swift Package Manager), Swift
      // (2015‐04‐24)

      let arguments = ProcessInfo.processInfo.arguments.dropFirst()
      switch arguments.first {
      case "format":
        try package.format(reportProgress: { print($0) })
      case "prepare‐c":
        try C.prepare(package: package)
      case "prepare‐c‐sharp":
        try CSharp.prepare(package: package)
      case "prepare‐kotlin":
        try Kotlin.prepare(package: package)
      case "build‐javascript":
        try JavaScript.prepare(package: package)
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
        try package.testSwift()
      }
    } catch let errorList as ErrorList<FileParseError<ParsedDeclarationList.ParseError>> {
      for error in errorList.errors {
        print(error.diagnostic)
      }
      fatalError()
    } catch let errorList as ErrorList<ActionIntermediate.ConstructionError> {
      for error in errorList.errors {
        print(error.diagnostic)
      }
      fatalError()
    } catch let error {
      fatalError("\(error)")
    }
  }
}
