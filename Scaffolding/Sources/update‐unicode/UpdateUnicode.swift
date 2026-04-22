import Foundation

import SDGPersistence

@main struct UpdateUnicode {

  static let version = "17.0.0"
  static let databaseURL = URL(string: "http://www.unicode.org/Public/\(version)/ucd/UnicodeData.txt")!
  static let firstScalar = Unicode.Scalar(0x0000)!
  static let lastScalar = Unicode.Scalar(0x10FFFF)!
  static let firstHangulSyllable: UInt32 = 0xAC00
  static let lastHangulSyllable: UInt32 = firstHangulSyllable + 11172 - 1

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
    var decompositions: [Unicode.Scalar: [Unicode.Scalar]] = [:]

    try populateFromDatabase(classes: &classes, decompositions: &decompositions)
    resolveRecursion(decompositions: &decompositions)
    checkForDifferencesFromSystem(classes: classes, decompositions: &decompositions)
    try outputFiles(classes: classes, decompositions: decompositions)
  }

  static func populateFromDatabase(
    classes: inout [Unicode.Scalar: UInt8],
    decompositions: inout [Unicode.Scalar: [Unicode.Scalar]]
  ) throws {
    for entry in try String(from: databaseURL).components(separatedBy: "\n") as [String]
      where !entry.isEmpty {
      let entryComponents: [String] = entry.components(separatedBy: ";")

      let scalarValueString = entryComponents[0]
      guard let scalar = Unicode.Scalar(hexadecimal: scalarValueString) else {
        if let generalCategory = entryComponents.prefix(3).last,
          String(generalCategory) == "Cs" /* surrogate */ {
          continue
        }
        fatalError("Unable to parse scalar: \(scalarValueString) (\(entry))")
      }

      let classString = entryComponents[3]
      guard let combiningClass = UInt8(classString, radix: 10) else {
        fatalError("Unable to parse canonical combining class: \(classString) (\(entry))")
      }
      classes[scalar] = combiningClass

      let decompositionString = entryComponents[5]
      if !decompositionString.isEmpty {
        var decomposition: [String] = decompositionString.components(separatedBy: " ")
        if decomposition.first?.first == "<" {
          decomposition.removeFirst()
        }
        let decomposedScalars: [Unicode.Scalar] = decomposition.map { hexadecimal in
          guard let scalar = Unicode.Scalar(hexadecimal: hexadecimal) else {
            fatalError("Unable to parse scalar: \(hexadecimal) (\(entry))")
          }
          return scalar
        }
        decompositions[scalar] = decomposedScalars
      }
    }
  }

  static func resolveRecursion(decompositions: inout [Unicode.Scalar: [Unicode.Scalar]]) {
    for key in decompositions.keys {
      var notFinished = true
      var result = decompositions[key]!
      while notFinished {
        notFinished = false
        let copy = result
        result = []
        for scalar in copy {
          if let replacement = decompositions[scalar] {
            notFinished = true
            result.append(contentsOf: replacement)
          } else {
            result.append(scalar)
          }
        }
      }
      decompositions[key] = result
    }
  }

  static func checkForDifferencesFromSystem(
    classes: [Unicode.Scalar: UInt8],
    decompositions: inout [Unicode.Scalar: [Unicode.Scalar]]
  ) {
    for value in firstScalar.value ... lastScalar.value {
      if let scalar = Unicode.Scalar(value),
        scalar.properties.generalCategory != .unassigned {

        let combiningClass = classes[scalar] ?? 0
        let systemClass = scalar.properties.canonicalCombiningClass.rawValue
        if combiningClass != systemClass {
          print("Canonical combining class differs from system: \(String(hexadecimal: value)), \(combiningClass) ≠ \(systemClass)")
        }

        let decomposition = decompositions[scalar] ?? [scalar]
        let systemDecomposition = String(scalar).decomposedStringWithCompatibilityMapping.unicodeScalars
        if !decomposition.elementsEqual(systemDecomposition),
           !(firstHangulSyllable ... lastHangulSyllable).contains(value) {
          print("Compatibility decomposition differs from system: \(String(hexadecimal: value)), \(decomposition.map({ String(hexadecimal: $0.value) })) ≠ \(systemDecomposition.map({ String(hexadecimal: $0.value) }))")
        }
      }
    }
  }

  static func outputFiles(
    classes: [Unicode.Scalar: UInt8],
    decompositions: [Unicode.Scalar: [Unicode.Scalar]]
  ) throws {
    try output(classes: classes)
    try output(decompositions: decompositions)
    try output(decompositionCheck: decompositions)
  }

  static func output(classes: [Unicode.Scalar: UInt8]) throws {
    var source: [String] = [
      "action (unit)",
    ]
    source.append(contentsOf: [
      " (",
      "  English: canonical combining class of (scalar: Unicode scalar numerical value)",
      " )",
      " 8‐bit natural number",
      " {",
    ])
    var previous: (scalar: Unicode.Scalar, combiningClass: UInt8)?
    for value in firstScalar.value ... lastScalar.value {
      if let scalar = Unicode.Scalar(value) {
        let combiningClass = classes[scalar] ?? 0
        defer { previous = (scalar: scalar, combiningClass: combiningClass) }
        if let previous = previous,
          combiningClass != previous.combiningClass {
          let literalScalar = previous.scalar.sayingLiteral
          source.append(contentsOf: [
            "  if ((scalar) is less than or equal to (“\(literalScalar)”: Unicode scalar numerical value)), {",
            "   ← “\(previous.combiningClass)”",
            "  }",
          ])
        }
      }
    }
    source.append(contentsOf: [
      "  ← “\(classes[lastScalar] ?? 0)”",
    ])
    source.append(contentsOf: [
      " }",
    ])

    try source.joined(separator: "\n").appending("\n")
      .overrwite(unicodeDirectory.appendingPathComponent("Canonical Combining Class.git.utf8.saying"))
  }

  static func output(decompositions: [Unicode.Scalar: [Unicode.Scalar]]) throws {
    var source: [String] = [
      "action (unit)",
      " (",
      "  English: full compatibility decomposition of (scalar: Unicode scalar)",
      " )",
      " Unicode scalars",
      " {",
      "  let (• value: Unicode scalar numerical value) be ((numerical value) of (scalar))",
    ]
    var previous: (scalar: Unicode.Scalar, decomposition: [Unicode.Scalar])?
    let noChange = "(scalar) as scalars"
    for value in firstScalar.value ... lastScalar.value {
      if let scalar = Unicode.Scalar(value) {
        let decomposition = decompositions[scalar] ?? []
        defer { previous = (scalar: scalar, decomposition: decomposition) }
        if let previous = previous,
          decomposition != previous.decomposition
            || value == firstHangulSyllable || value == lastHangulSyllable + 1 {
          let literalScalar = previous.scalar.sayingLiteral
          let literalString = previous.decomposition.isEmpty
            ? (previous.scalar.value == lastHangulSyllable ? "(value)의 자모" : noChange)
            : "“\(previous.decomposition.map({ "¤(\($0.sayingLiteral))" }).joined())”"
          source.append(contentsOf: [
            "  if ((value) is less than or equal to (“\(literalScalar)”: Unicode scalar numerical value)), {",
            "   ← \(literalString)",
            "  }",
          ])
        }
      }
    }
    source.append(contentsOf: [
      "  ← \(noChange)",
    ])
    source.append(contentsOf: [
      " }",
    ])

    try source.joined(separator: "\n").appending("\n")
      .overrwite(unicodeDirectory.appendingPathComponent("Compatibility Decomposition.git.utf8.saying"))
  }

  static func output(decompositionCheck: [Unicode.Scalar: [Unicode.Scalar]]) throws {
    var source: [String] = [
      "action (unit)",
      " (",
      "  English: compatibility decomposition quick check of (scalar: Unicode scalar numerical value)",
      " )",
      " truth value",
      " {",
    ]
    var previous: (scalar: Unicode.Scalar, decompositionCheck: Bool)?
    for value in firstScalar.value ... lastScalar.value {
      if let scalar = Unicode.Scalar(value) {
        let validity = decompositionCheck[scalar] == nil
        defer { previous = (scalar: scalar, decompositionCheck: validity) }
        if let previous = previous,
           validity != previous.decompositionCheck
            || value == firstHangulSyllable || value == lastHangulSyllable + 1 {
          let literalScalar = previous.scalar.sayingLiteral
          let literalValue = previous.scalar.value == lastHangulSyllable ? false : previous.decompositionCheck
          source.append(contentsOf: [
            "  if ((scalar) is less than or equal to (“\(literalScalar)”: Unicode scalar numerical value)), {",
            "   ← \(literalValue)",
            "  }",
          ])
        }
      }
    }
    source.append(contentsOf: [
      "  ← true",
    ])
    source.append(contentsOf: [
      " }",
    ])

    try source.joined(separator: "\n").appending("\n")
      .overrwite(unicodeDirectory.appendingPathComponent("Compatibility Decomposition Quick Check.git.utf8.saying"))
  }
}
