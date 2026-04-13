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
    var decompositions: [Unicode.Scalar: [Unicode.Scalar]] = [:]

    try populateFromDatabase(classes: &classes, decompositions: &decompositions)
    resolveRecursion(decompositions: &decompositions)
    checkForDifferencesFromSystem(classes: classes, decompositions: &decompositions)
    try outputFiles(classes: classes)
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
    for value in 0x0000...0x10FFFF {
      if let scalar = Unicode.Scalar(value),
        scalar.properties.generalCategory != .unassigned {

        let combiningClass = classes[scalar] ?? 0
        let systemClass = scalar.properties.canonicalCombiningClass.rawValue
        if combiningClass != systemClass {
          print("Canonical combining class differs from system: \(String(hexadecimal: value)), \(combiningClass) ≠ \(systemClass)")
        }

        let decomposition = decompositions[scalar] ?? [scalar]
        let systemDecomposition = String(scalar).decomposedStringWithCompatibilityMapping.unicodeScalars
        if !decomposition.elementsEqual(systemDecomposition) {
          print("Compatibility decomposition differs from system: \(String(hexadecimal: value)), \(decomposition.map({ String(hexadecimal: $0.value) })) ≠ \(systemDecomposition.map({ String(hexadecimal: $0.value) }))")
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
