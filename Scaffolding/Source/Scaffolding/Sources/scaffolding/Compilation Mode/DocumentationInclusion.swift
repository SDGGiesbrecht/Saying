enum DocumentationInclusion {
  /// All documentation.
  case all
  /// Only reachable documentation.
  case reachable
  /// No documentation is produced, but the contents are still compiled to detect errors.
  case errorDetection
  /// No documentation.
  case none
}
