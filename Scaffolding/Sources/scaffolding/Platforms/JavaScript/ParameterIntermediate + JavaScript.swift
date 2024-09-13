import SDGText

extension ParameterIntermediate {

  func javaScriptSource(module: ModuleIntermediate) -> String {
    return String(JavaScript.sanitize(identifier: names.identifier(), leading: false))
  }
}
