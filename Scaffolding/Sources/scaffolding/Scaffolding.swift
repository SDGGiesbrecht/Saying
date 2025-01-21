import Foundation

import SDGText

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

    // Android: from Linux, Android Studio (Gradle), Kotlin
    // (2008‐09‐23)

    // Amazon Linux: MATE, Developer Tools (GNU Compiler Collection (gcc)), C
    // (2011‐09‐26)

    // watchOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2015‐04‐24)

    let arguments = ProcessInfo.processInfo.arguments.dropFirst()
    switch arguments.first {
    case "rescaffold":
      try rescaffold(from: package, packageRoot: packageRoot)
    case "format":
      try package.format(reportProgress: { print(StrictString($0)) })
    case "prepare‐c":
      try C.prepare(package: package, mode: .testing)
    case "prepare‐c‐sharp":
      try CSharp.prepare(package: package, mode: .testing)
    case "prepare‐kotlin":
      try Kotlin.prepare(package: package, mode: .testing)
    case "build‐javascript":
      try JavaScript.prepare(package: package, mode: .testing)
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
  }

  static func rescaffold(from package: Package, packageRoot: URL) throws {
    let file = packageRoot
      .appendingPathComponent("Scaffolding")
      .appendingPathComponent("Sources")
      .appendingPathComponent("scaffolding")
      .appendingPathComponent("Generated")
      .appendingPathComponent("Saying.swift")
    try Swift.prepare(
      package: package,
      mode: .release,
      entryPoints: [
        "compute(_: () -> Set<Unicode.Scalar>, cachingIn: Set<Unicode.Scalar>?)",
        "UnicodeText",

        "DownArrowSyntax",
        "LeftArrowSyntax",
        "RightArrowSyntax",
        "ClosingBraceSyntax",
        "OpeningBraceSyntax",
        "ClosingBracketSyntax",
        "OpeningBracketSyntax",
        "ClosingParenthesisSyntax",
        "OpeningParenthesisSyntax",
        "LineBreakSyntax",
        "ParagraphBreakSyntax",
        "BulletCharacterSyntax",
        "ColonCharacterSyntax",
        "LeftChevronQuotationMarkSyntax",
        "LowQuotationMarkSyntax",
        "NinesQuotationMarkSyntax",
        "RightChevronQuotationMarkSyntax",
        "SixesQuotationMarkSyntax",
        "SlashSyntax",
        "SpaceSyntax",
        "SymbolInsertionMarkSyntax",
        "ReplacementParsedDownArrowSyntax",
        "ReplacementParsedLeftArrowSyntax",
        "ReplacementParsedRightArrowSyntax",
        "ReplacementParsedClosingBraceSyntax",
        "ReplacementParsedOpeningBraceSyntax",
        "ReplacementParsedClosingBracketSyntax",
        "ReplacementParsedOpeningBracketSyntax",
        "ReplacementParsedClosingParenthesisSyntax",
        "ReplacementParsedOpeningParenthesisSyntax",
        "ReplacementParsedLineBreakSyntax",
        "ReplacementParsedParagraphBreakSyntax",
        "ReplacementParsedBulletCharacterSyntax",
        "ReplacementParsedColonCharacterSyntax",
        "ReplacementParsedLeftChevronQuotationMarkSyntax",
        "ReplacementParsedLowQuotationMarkSyntax",
        "ReplacementParsedNinesQuotationMarkSyntax",
        "ReplacementParsedRightChevronQuotationMarkSyntax",
        "ReplacementParsedSixesQuotationMarkSyntax",
        "ReplacementParsedSlashSyntax",
        "ReplacementParsedSpaceSyntax",
        "ReplacementParsedSymbolInsertionMarkSyntax",
      ],
      location: file
    )
    var source = try String(from: file)
    source.append(contentsOf: [
      "",
      "import SDGText",
      "",
      "extension StrictString {",
      "  init(_ text: UnicodeText) {",
      "    self.init(text.scalars)",
      "  }",
      "}",
      "",
      "extension UnicodeText {",
      "  init(_ string: StrictString) {",
      "    scalars = String(string)",
      "  }",
      "}",
      "",
    ].joined(separator: "\n"))
    try source.save(to: file)
  }
}
