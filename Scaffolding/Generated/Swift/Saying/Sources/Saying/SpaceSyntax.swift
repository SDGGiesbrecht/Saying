public struct SpaceSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension SpaceSyntax {
  public static var scalar: Unicode.Scalar {
    return " " as Unicode.Scalar
  }
}
