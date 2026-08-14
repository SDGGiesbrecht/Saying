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

    var entryPoints: Set<UnicodeText> = [
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
    ]
    for node in [
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
      "OpeningQuestionMarkSyntax",
      "ClosingQuestionMarkSyntax",
      "RightToLeftQuestionMarkSyntax",
      "GreekQuestionMarkSyntax",
      "OpeningExclamationMarkSyntax",
      "ClosingExclamationMarkSyntax",
      "ColonCharacterSyntax",
      "LeftChevronQuotationMarkSyntax",
      "LowQuotationMarkSyntax",
      "NinesQuotationMarkSyntax",
      "RightChevronQuotationMarkSyntax",
      "SixesQuotationMarkSyntax",
      "SlashSyntax",
      "SpaceSyntax",
      "SymbolInsertionMarkSyntax",
    ] as [UnicodeText] {
      entryPoints.insert("\(node).scalar")
      entryPoints.insert("\(node).init()")
      entryPoints.insert("\(node).type")
      entryPoints.insert("Parsed\(node).type")
      entryPoints.insert("\(node).children")
      entryPoints.insert("Parsed\(node).children")
    }

    try Swift.prepare(
      package: package,
      mode: .scaffolding,
      entryPoints: entryPoints,
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
