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

    // Ubuntu: GNOME Builder (Meson), GNOME, GTK, GLib, C
    // (2004‐10‐20)

    // tvOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2007‐01‐09)

    // iOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2007‐06‐29)

    // Android: from Linux, Android Studio (Gradle), Kotlin
    // (2008‐09‐23)

    // Amazon Linux: MATE, Development Tools, GTK, GLib, C
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

        "==(_: UnicodeSegments.Index, _: UnicodeSegments.Index)",
        "<(_: UnicodeSegments.Index, _: UnicodeSegments.Index)",
        "UnicodeSegments",
        "DownArrowSyntax.init()",
        "LeftArrowSyntax.init()",
        "RightArrowSyntax.init()",
        "ClosingBraceSyntax.init()",
        "OpeningBraceSyntax.init()",
        "ClosingBracketSyntax.init()",
        "OpeningBracketSyntax.init()",
        "ClosingParenthesisSyntax.init()",
        "OpeningParenthesisSyntax.init()",
        "LineBreakSyntax.init()",
        "ParagraphBreakSyntax.init()",
        "BulletCharacterSyntax.init()",
        "OpeningQuestionMarkSyntax.init()",
        "ClosingQuestionMarkSyntax.init()",
        "RightToLeftQuestionMarkSyntax.init()",
        "OpeningExclamationMarkSyntax.init()",
        "ClosingExclamationMarkSyntax.init()",
        "ColonCharacterSyntax.init()",
        "LeftChevronQuotationMarkSyntax.init()",
        "LowQuotationMarkSyntax.init()",
        "NinesQuotationMarkSyntax.init()",
        "RightChevronQuotationMarkSyntax.init()",
        "SixesQuotationMarkSyntax.init()",
        "SlashSyntax.init()",
        "SpaceSyntax.init()",
        "SymbolInsertionMarkSyntax.init()",
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
        "ReplacementOpeningQuestionMarkSyntax.init()",
        "ReplacementClosingQuestionMarkSyntax.init()",
        "ReplacementRightToLeftQuestionMarkSyntax.init()",
        "ReplacementOpeningExclamationMarkSyntax.init()",
        "ReplacementClosingExclamationMarkSyntax.init()",
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
      "    self.init(String(string).unicodeScalars)",
      "  }",
      "}",
      "",
      "struct UnicodeSegment {",
      "  fileprivate var segment: Unicode_0020segment",
      "}",
      "",
      "extension UnicodeSegment {",
      "  init(scalarOffset: UInt64, source: UnicodeText) {",
      "    self.init(segment: Unicode_0020segment(scalarOffset, source))",
      "  }",
      "  var scalarOffset: UInt64 {",
      "    return segment.scalar_0020offset",
      "  }",
      "  var source: UnicodeText {",
      "    return segment.source",
      "  }",
      "}",
      "",
      "extension UnicodeSegments.Index {",
      "  init(segment: Int, scalar: String.UnicodeScalarView.Index?) {",
      "    self.init(segment, scalar)",
      "  }",
      "  var segmentIndex: Int {",
      "    return segment",
      "  }",
      "  var scalarIndex: String.UnicodeScalarView.Index? {",
      "    return scalar",
      "  }",
      "}",
      "",
      "extension UnicodeSegments {",
      "  init(segments: [UnicodeSegment]) {",
      "    self.init(segments.map({ $0.segment }))",
      "  }",
      "  var segmentIndices: Range<Int> {",
      "    return segments.indices",
      "  }",
      "  func segment(at index: Int) -> UnicodeSegment {",
      "    return UnicodeSegment(segment: segments[index])",
      "  }",
      "}",
      "",
    ].joined(separator: "\n"))
    try source.save(to: file)
  }
}
