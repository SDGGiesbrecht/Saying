enum ComponentInclusion {
  /// All components.
  case all
  /// At least one component for every source‐level element, but otherwise excluding unreachable parallel components.
  ///
  /// This mode ensures each extension is exercised at least once, without wasting effort on its every possible permutation.
  case unique
  /// Only reachable components.
  case reachable
}
