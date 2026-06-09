extension String {

  init(_ text: UnicodeText) {
    self.init(String.UnicodeScalarView(text))
  }
}

func compute(_ compute: () -> String, cachingIn cache: inout String?) -> String {
  if let cached = cache {
    return cached
  }
  let result: String = compute()
  cache = result
  return result
}
