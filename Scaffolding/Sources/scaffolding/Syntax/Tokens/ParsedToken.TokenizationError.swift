extension ParsedToken {
  enum TokenizationError: Error {
    case invalidScalar(Unicode.Scalar)
  }
}
