public struct ErrorList<Element>: Error where Element: DiagnosticError {

  public init(_ errors: [Element]) {
    self.errors = errors
  }

  public var errors: [Element]
}

extension ErrorList {
  public func map<NewElement>(_ closure: (Element) -> NewElement) -> ErrorList<NewElement> {
    return ErrorList<NewElement>(errors.map(closure))
  }
}

extension ErrorList: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}
