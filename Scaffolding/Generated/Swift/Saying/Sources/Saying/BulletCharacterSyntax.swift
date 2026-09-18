public struct BulletCharacterSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension BulletCharacterSyntax {
  public static var scalar: Unicode.Scalar {
    return "•" as Unicode.Scalar
  }
}
