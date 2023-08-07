extension ParsedUninterruptedIdentifier {

  enum ParseError: Error {
  case missingToken(UTF8Segments.Index)
  case initialSpace(OldParsedToken)
  case consecutiveSpaces([OldParsedToken])
  case finalSpace(OldParsedToken)
  }
}
