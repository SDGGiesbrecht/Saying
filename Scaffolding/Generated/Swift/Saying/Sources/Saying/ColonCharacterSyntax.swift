public struct ColonCharacterSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.colonCharacterSyntax(self)
  }
}

extension ColonCharacterSyntax {
  public static var scalar: Unicode.Scalar {
    return ":" as Unicode.Scalar
  }
}
