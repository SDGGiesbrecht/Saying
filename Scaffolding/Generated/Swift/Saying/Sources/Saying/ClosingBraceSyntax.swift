public struct ClosingBraceSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension ClosingBraceSyntax {
  public static var scalar: Unicode.Scalar {
    return "}" as Unicode.Scalar
  }
}
