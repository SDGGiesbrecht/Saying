public struct SlashSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.slashSyntax(self)
  }
}

extension SlashSyntax {
  public static var scalar: Unicode.Scalar {
    return "/" as Unicode.Scalar
  }
}
