public struct DownArrowSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension DownArrowSyntax {
  public static var scalar: Unicode.Scalar {
    return "↓" as Unicode.Scalar
  }
}
