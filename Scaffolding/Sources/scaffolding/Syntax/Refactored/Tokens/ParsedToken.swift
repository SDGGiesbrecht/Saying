protocol ParsedToken {
  var tokenKind: ParsedTokenKind { get }
  var location: Slice<UTF8Segments> { get }
}
