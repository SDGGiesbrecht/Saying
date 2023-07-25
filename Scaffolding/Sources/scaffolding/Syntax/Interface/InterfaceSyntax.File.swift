extension InterfaceSyntax {
  struct File {
    let tokens: [ParsedToken]
    let location: Slice<UTF8Segments>
  }
}
