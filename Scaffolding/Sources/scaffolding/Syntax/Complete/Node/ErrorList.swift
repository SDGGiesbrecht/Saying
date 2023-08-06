struct ErrorList<Element>: Error where Element: Error {

  init(_ errors: [Element]) {
    self.errors = errors
  }

  var errors: [Element]
}

extension ErrorList: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}
