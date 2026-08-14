import Foundation

import Saying

@main struct Scaffolding {
  static func main() throws {
    let thisFile = URL(fileURLWithPath: #filePath)
    let packageRoot = thisFile
      .deletingLastPathComponent()
      .deletingLastPathComponent()
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

    // Ubuntu: build-essential (Make), C
    // (2004‐10‐20)

    // tvOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2007‐01‐09)

    // iOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2007‐06‐29)

    // Android: from Linux, Android Studio (Gradle), Kotlin
    // (2008‐09‐23)

    // Amazon Linux: Development Tools (Make), C
    // (2011‐09‐26)

    // watchOS: from macOS, Xcode (Swift Package Manager), Swift
    // (2015‐04‐24)

    let reportProgress: (String) -> Void = { print($0) }
    
    let arguments = ProcessInfo.processInfo.arguments.dropFirst()
    switch arguments.first {
    case "rescaffold":
      try rescaffold(from: package, packageRoot: packageRoot, reportProgress: reportProgress)
    case "format":
      try package.format(reportProgress: reportProgress)
    case "prepare‐c":
      try C.prepare(package: package, mode: .testing, reportProgress: reportProgress)
    case "prepare‐c‐sharp":
      try CSharp.prepare(package: package, mode: .testing, reportProgress: reportProgress)
    case "prepare‐kotlin":
      try Kotlin.prepare(package: package, mode: .testing, reportProgress: reportProgress)
    case "build‐javascript":
      try JavaScript.prepare(package: package, mode: .testing, reportProgress: reportProgress)
    case "test‐c":
      try package.testC(reportProgress: reportProgress)
    case "test‐swift":
      try package.testSwift(reportProgress: reportProgress)
    case "test‐tvos":
      try package.testTVOS(reportProgress: reportProgress)
    case "test‐ios":
      try package.testIOS(reportProgress: reportProgress)
    case "test‐watchos":
      try package.testWatchOS(reportProgress: reportProgress)
    default:
      try package.testSwift(reportProgress: reportProgress)
    }
  }

  static func rescaffold(
    from package: Package,
    packageRoot: URL,
    reportProgress: @escaping (String) -> Void
  ) throws {

    var shims: [String] = [
      "extension SayingSourceSlice {",
      "  public init(origin: UnicodeText, code: SayingSourceCodeSlice) {",
      "    self.init(origin, code)",
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
      shims.append(contentsOf: [
        "",
        "extension \(nodeType) {",
        "  public init(location: SayingSourceSlice) {",
        "    self.init(location)",
        "  }",
        "}",
      ])
    }
    shims.append(contentsOf: [
      "",
    ])

    try Swift.prepare(
      package: package,
      mode: .scaffolding,
      entryPoints: [
        "compute(_: () -> Set<Unicode.Scalar>, cachingIn: Set<Unicode.Scalar>?)",
        "UnicodeText.init(_: String.UnicodeScalarView)",
        "UnicodeText.init(_: UnicodeText)",
        "String.UnicodeScalarView.init(_: UnicodeText)",
        "UnicodeText.prepend(contentsOf: UnicodeText)",
        "[UnicodeText].joined()",
        "[UnicodeText].joined(separator: UnicodeText)",
        "UnicodeText.replace(_: UnicodeText, with: UnicodeText)",
        "[Set<UnicodeText>].appending(_: Set<UnicodeText>)",

        "UnicodeSegments.init(allOf: UnicodeText)",
        "UnicodeSegments.index(before: UnicodeSegments.Boundary)",
        "UnicodeText.init(_: Slice<UnicodeSegments>)",
        "UnicodeSegments.underlyingScalarOffset(of: UnicodeSegments.Boundary)",
        "GitStyleSayingSource.init(origin: UnicodeText, code: UnicodeText)",
        "GitStyleSayingSource.parsed()",
        "DownArrowSyntax.init()",
        "DownArrowSyntax.scalar",
        "LeftArrowSyntax.init()",
        "LeftArrowSyntax.scalar",
        "RightArrowSyntax.init()",
        "RightArrowSyntax.scalar",
        "ClosingBraceSyntax.init()",
        "ClosingBraceSyntax.scalar",
        "OpeningBraceSyntax.init()",
        "OpeningBraceSyntax.scalar",
        "ClosingBracketSyntax.init()",
        "ClosingBracketSyntax.scalar",
        "OpeningBracketSyntax.init()",
        "OpeningBracketSyntax.scalar",
        "ClosingParenthesisSyntax.init()",
        "ClosingParenthesisSyntax.scalar",
        "OpeningParenthesisSyntax.init()",
        "OpeningParenthesisSyntax.scalar",
        "LineBreakSyntax.init()",
        "LineBreakSyntax.scalar",
        "ParagraphBreakSyntax.init()",
        "ParagraphBreakSyntax.scalar",
        "BulletCharacterSyntax.init()",
        "BulletCharacterSyntax.scalar",
        "OpeningQuestionMarkSyntax.init()",
        "OpeningQuestionMarkSyntax.scalar",
        "ClosingQuestionMarkSyntax.init()",
        "ClosingQuestionMarkSyntax.scalar",
        "RightToLeftQuestionMarkSyntax.init()",
        "RightToLeftQuestionMarkSyntax.scalar",
        "GreekQuestionMarkSyntax.init()",
        "GreekQuestionMarkSyntax.scalar",
        "OpeningExclamationMarkSyntax.init()",
        "OpeningExclamationMarkSyntax.scalar",
        "ClosingExclamationMarkSyntax.init()",
        "ClosingExclamationMarkSyntax.scalar",
        "ColonCharacterSyntax.init()",
        "ColonCharacterSyntax.scalar",
        "LeftChevronQuotationMarkSyntax.init()",
        "LeftChevronQuotationMarkSyntax.scalar",
        "LowQuotationMarkSyntax.init()",
        "LowQuotationMarkSyntax.scalar",
        "NinesQuotationMarkSyntax.init()",
        "NinesQuotationMarkSyntax.scalar",
        "RightChevronQuotationMarkSyntax.init()",
        "RightChevronQuotationMarkSyntax.scalar",
        "SixesQuotationMarkSyntax.init()",
        "SixesQuotationMarkSyntax.scalar",
        "SlashSyntax.init()",
        "SlashSyntax.scalar",
        "SpaceSyntax.init()",
        "SpaceSyntax.scalar",
        "SymbolInsertionMarkSyntax.init()",
        "SymbolInsertionMarkSyntax.scalar",
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
        "DownArrowSyntax.type",
        "LeftArrowSyntax.type",
        "RightArrowSyntax.type",
        "ClosingBraceSyntax.type",
        "OpeningBraceSyntax.type",
        "ClosingBracketSyntax.type",
        "OpeningBracketSyntax.type",
        "ClosingParenthesisSyntax.type",
        "OpeningParenthesisSyntax.type",
        "LineBreakSyntax.type",
        "ParagraphBreakSyntax.type",
        "BulletCharacterSyntax.type",
        "OpeningQuestionMarkSyntax.type",
        "ClosingQuestionMarkSyntax.type",
        "RightToLeftQuestionMarkSyntax.type",
        "GreekQuestionMarkSyntax.type",
        "OpeningExclamationMarkSyntax.type",
        "ClosingExclamationMarkSyntax.type",
        "ColonCharacterSyntax.type",
        "LeftChevronQuotationMarkSyntax.type",
        "LowQuotationMarkSyntax.type",
        "NinesQuotationMarkSyntax.type",
        "RightChevronQuotationMarkSyntax.type",
        "SixesQuotationMarkSyntax.type",
        "SlashSyntax.type",
        "SpaceSyntax.type",
        "SymbolInsertionMarkSyntax.type",
      ],
      location: packageRoot
        .appendingPathComponent("Scaffolding")
        .appendingPathComponent("Generated")
        .appendingPathComponent("Swift")
        .appendingPathComponent("Saying"),
      shims: shims.joined(separator: "\n"),
      reportProgress: reportProgress
    )
  }
}
