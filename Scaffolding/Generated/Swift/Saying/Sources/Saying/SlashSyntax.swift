public struct SlashSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension SlashSyntax {
  public static var scalar: Unicode.Scalar {
    return "/" as Unicode.Scalar
  }
}
