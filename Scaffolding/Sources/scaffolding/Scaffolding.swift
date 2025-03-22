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
    // • .NET Framework
    // (2002‐02‐13)
    // • .NET
    // (2016‐06‐27 .NET Core)

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
        "UnicodeSegments.startIndex",
        "UnicodeSegments.endIndex",
        "UnicodeSegments.index(after: UnicodeSegments.Index)",
        "UnicodeSegments.subscript(_: UnicodeSegments.Index)",
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
        "GreekQuestionMarkSyntax.init()",
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
        "ParsedDownArrowSyntax.location",
        "ParsedLeftArrowSyntax.location",
        "ParsedRightArrowSyntax.location",
        "ParsedClosingBraceSyntax.location",
        "ParsedOpeningBraceSyntax.location",
        "ParsedClosingBracketSyntax.location",
        "ParsedOpeningBracketSyntax.location",
        "ParsedClosingParenthesisSyntax.location",
        "ParsedOpeningParenthesisSyntax.location",
        "ParsedLineBreakSyntax.location",
        "ParsedParagraphBreakSyntax.location",
        "ParsedBulletCharacterSyntax.location",
        "ParsedOpeningQuestionMarkSyntax.location",
        "ParsedClosingQuestionMarkSyntax.location",
        "ParsedRightToLeftQuestionMarkSyntax.location",
        "ParsedGreekQuestionMarkSyntax.location",
        "ParsedOpeningExclamationMarkSyntax.location",
        "ParsedClosingExclamationMarkSyntax.location",
        "ParsedColonCharacterSyntax.location",
        "ParsedLeftChevronQuotationMarkSyntax.location",
        "ParsedLowQuotationMarkSyntax.location",
        "ParsedNinesQuotationMarkSyntax.location",
        "ParsedRightChevronQuotationMarkSyntax.location",
        "ParsedSixesQuotationMarkSyntax.location",
        "ParsedSlashSyntax.location",
        "ParsedSpaceSyntax.location",
        "ParsedSymbolInsertionMarkSyntax.location",
      ],
      location: file
    )
    var source = try String(from: file)
    var appendix: [String] = [
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
    ]
    for nodeType in [
      "ParsedDownArrowSyntax",
      "ParsedLeftArrowSyntax",
      "ParsedRightArrowSyntax",
      "ParsedClosingBraceSyntax",
      "ParsedOpeningBraceSyntax",
      "ParsedClosingBracketSyntax",
      "ParsedOpeningBracketSyntax",
      "ParsedClosingParenthesisSyntax",
      "ParsedOpeningParenthesisSyntax",
      "ParsedLineBreakSyntax",
      "ParsedParagraphBreakSyntax",
      "ParsedBulletCharacterSyntax",
      "ParsedOpeningQuestionMarkSyntax",
      "ParsedClosingQuestionMarkSyntax",
      "ParsedRightToLeftQuestionMarkSyntax",
      "ParsedGreekQuestionMarkSyntax",
      "ParsedOpeningExclamationMarkSyntax",
      "ParsedClosingExclamationMarkSyntax",
      "ParsedColonCharacterSyntax",
      "ParsedLeftChevronQuotationMarkSyntax",
      "ParsedLowQuotationMarkSyntax",
      "ParsedNinesQuotationMarkSyntax",
      "ParsedRightChevronQuotationMarkSyntax",
      "ParsedSixesQuotationMarkSyntax",
      "ParsedSlashSyntax",
      "ParsedSpaceSyntax",
      "ParsedSymbolInsertionMarkSyntax",
    ] {
      appendix.append(contentsOf: [
        "",
        "extension \(nodeType) {",
        "  init(location: Slice<UnicodeSegments>) {",
        "    self.init(location)",
        "  }",
        "}",
      ])
    }
    source.append(contentsOf: appendix.joined(separator: "\n"))
    try source.save(to: file)
  }
}
