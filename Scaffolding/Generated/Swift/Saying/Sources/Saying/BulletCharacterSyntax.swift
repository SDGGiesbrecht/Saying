public struct BulletCharacterSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.bulletCharacterSyntax(self)
  }
}

extension BulletCharacterSyntax {
  public static var scalar: Unicode.Scalar {
    return "•" as Unicode.Scalar
  }
}
