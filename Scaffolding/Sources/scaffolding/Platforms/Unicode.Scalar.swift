import SDGLogic
import SDGText

extension Unicode.Scalar {
  
  var isVulnerableToNormalization: Bool {
    return properties.canonicalCombiningClass != .notReordered
      ∨ isDecomposableInNFKD
  }
}
