import Foundation

import SDGPersistence

@main struct UpdateUnicode {

  static let version = "17.0.0"
  static let databaseURL = URL(string: "http://www.unicode.org/Public/\(version)/ucd/UnicodeData.txt")!
  static let lastScalar = Unicode.Scalar(0x10FFFF)!

  static let thisFile = URL(fileURLWithPath: #filePath)
  static let projectRoot = thisFile
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
  static let generatedDirectory = projectRoot
    .appendingPathComponent("Source")
    .appendingPathComponent("Saying")
    .appendingPathComponent("Generated")
  static let unicodeDirectory = generatedDirectory
    .appendingPathComponent("Unicode")

  static func main() throws {
    var classes: [Unicode.Scalar: UInt8] = [:]

    try populateFromDatabase(classes: &classes)
    checkForDifferencesFromSystem(classes: classes)
    try outputFiles(classes: classes)
  }

  static func populateFromDatabase(classes: inout [Unicode.Scalar: UInt8]) throws {
    for databaseEntry in try String(from: databaseURL).components(separatedBy: "\n")
      where !databaseEntry.contents.isEmpty {
      let entry = String(databaseEntry.contents)
      let entryComponents = entry.components(separatedBy: ";")

      let scalarValueString = String(entryComponents[0].contents)
      guard let scalarValue = Int(hexadecimal: scalarValueString),
        let scalar = Unicode.Scalar(scalarValue) else {
        if let generalCategory = entryComponents.prefix(3).last,
          String(generalCategory.contents) == "Cs" /* surrogate */ {
          continue
        }
        fatalError("Unable to parse scalar: \(scalarValueString) (\(entry))")
      }

      let classString = String(entryComponents[3].contents)
      guard let combiningClass = UInt8(classString, radix: 10) else {
        fatalError("Unable to parse canonical combining class: \(classString) (\(entry))")
      }
      classes[scalar] = combiningClass
    }
  }

  static func checkForDifferencesFromSystem(classes: [Unicode.Scalar: UInt8]) {
    for value in 0x0000...0x10FFFF {
      if let scalar = Unicode.Scalar(value),
        scalar.properties.generalCategory != .unassigned {
        if classes[scalar] ?? 0 != scalar.properties.canonicalCombiningClass.rawValue {
          print("Canonical combining class differs from system: \(String(hexadecimal: value)), \(classes[scalar] ?? 0) ≠ \(scalar.properties.canonicalCombiningClass.rawValue)")
        }
      }
    }
  }

  static func outputFiles(classes: [Unicode.Scalar: UInt8]) throws {
    try output(classes: classes)
  }

  static func output(classes: [Unicode.Scalar: UInt8]) throws {
    var source: [String] = [
      "action (unit)",
      " [",
      "  test {ignore (canonical combining class of (“0000”: Unicode scalar numerical value))}",
    ]
    var implementation: [String] = []
    var previous: UInt8?
    for value in 0x0000...0x10FFFF {
      if let scalar = Unicode.Scalar(value) {
        let combiningClass = classes[scalar] ?? 0
        defer { previous = combiningClass }
        if let previous = previous,
          combiningClass != previous {
          var literalScalar = String(hexadecimal: scalar.value)
          while literalScalar.scalars.count < 4 {
            literalScalar = "0\(literalScalar)"
          }
          source.append(contentsOf: [
            "  test {ignore (canonical combining class of (“\(literalScalar)”: Unicode scalar numerical value))}",
          ])
          implementation.append(contentsOf: [
            "  if ((scalar) is less than (“\(literalScalar)”: Unicode scalar numerical value)), {",
            "   ← “\(previous)”",
            "  }",
          ])
        }
      }
    }
    implementation.append(contentsOf: [
      "  ← “\(classes[lastScalar] ?? 0)”",
    ])
    source.append(contentsOf: [
      " ]",
      " (",
      "  English: canonical combining class of (scalar: Unicode scalar numerical value)",
      " )",
      " 8‐bit natural number",
      " {",
    ])
    source.append(contentsOf: implementation)
    source.append(contentsOf: [
      " }",
    ])

    try source.joined(separator: "\n").appending("\n")
      .overrwite(unicodeDirectory.appendingPathComponent("Canonical Combining Class.git.utf8.saying"))
  }
}
