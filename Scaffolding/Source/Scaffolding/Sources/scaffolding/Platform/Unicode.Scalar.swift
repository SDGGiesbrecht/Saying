import Saying

extension Unicode.Scalar {

  var isVulnerableToNormalization: Bool {
    return combiningClass != .notReordered
      || !isDecomposedAccordingtoCompatibilityDecomposition
  }
}
