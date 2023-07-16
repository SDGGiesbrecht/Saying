extension Token {
  enum TokenizationError: Error {
    case invalidScalar(Unicode.Scalar)
  }
}
