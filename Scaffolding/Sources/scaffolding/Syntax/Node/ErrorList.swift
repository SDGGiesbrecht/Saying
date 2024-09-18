struct ErrorList<Element>: Error where Element: DiagnosticError {

  init(_ errors: [Element]) {
    self.errors = errors
  }

  var errors: [Element]
}

extension ErrorList {
  func map<NewElement>(_ closure: (Element) -> NewElement) -> ErrorList<NewElement> {
    return ErrorList<NewElement>(errors.map(closure))
  }
}

extension ErrorList: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}
