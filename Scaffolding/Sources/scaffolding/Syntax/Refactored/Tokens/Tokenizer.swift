enum Tokenizer {

  static func tokenize(source: UTF8Segments) -> [ParsedToken] {
    var parsed: [ParsedToken] = []
    var remainder = source[...]
    while let next = extractNext(from: &remainder) {
      parsed.append(next)
    }
    return parsed
  }
}
