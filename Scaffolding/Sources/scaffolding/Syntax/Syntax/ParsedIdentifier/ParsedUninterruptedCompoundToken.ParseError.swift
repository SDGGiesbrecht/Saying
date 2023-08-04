extension ParsedUninterruptedIdentifier {

  enum ParseError: Error {
  case missingToken(UTF8Segments.Index)
  case initialSpace(ParsedToken)
  case consecutiveSpaces([ParsedToken])
  case finalSpace(ParsedToken)
  }
}
