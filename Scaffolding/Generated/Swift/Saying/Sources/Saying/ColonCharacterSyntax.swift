public struct ColonCharacterSyntax {

  public init() {
  }
}

extension ColonCharacterSyntax {
  public static var scalar: Unicode.Scalar {
    return ":" as Unicode.Scalar
  }
}
