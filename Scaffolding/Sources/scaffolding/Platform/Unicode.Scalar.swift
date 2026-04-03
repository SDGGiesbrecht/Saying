extension Unicode.Scalar {
  
  var isVulnerableToNormalization: Bool {
    return combiningClass != .notReordered
      || isDecomposableInNFKD
  }
}
