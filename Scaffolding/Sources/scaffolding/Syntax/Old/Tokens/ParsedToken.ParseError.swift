extension ParsedToken {

  enum ParseError: Error {
    case none(UTF8Segments.Index)
    case multipleTokens([ParsedToken])
  }
}
