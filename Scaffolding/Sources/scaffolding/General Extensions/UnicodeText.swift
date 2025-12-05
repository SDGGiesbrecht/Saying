extension UnicodeText {

  init<Scalars>(_ scalars: Scalars) where Scalars : Sequence, Scalars.Element == Unicode.Scalar {
    if let text = scalars as? UnicodeText {
      self.init(text)
    } else if let slice = scalars as? Slice<UnicodeText> {
      self.init(slice)
    } else {
      self.init(String.UnicodeScalarView(scalars))
    }
  }

  init(_ string: String) {
    self.init(string.unicodeScalars)
  }
}

extension UnicodeText: CustomStringConvertible {

  var description: String {
    return String(self)
  }
}

extension UnicodeText: ExpressibleByStringInterpolation {}

extension UnicodeText: ExpressibleByStringLiteral {

  init(stringLiteral value: String) {
    self.init(value)
  }
}

extension UnicodeText: Hashable {}

extension UnicodeText: RangeReplaceableCollection {

  init() {
    self = ""
  }

  mutating func replaceSubrange<C>(_ subrange: Range<String.UnicodeScalarView.Index>, with newElements: C)
  where C : Collection, Unicode.Scalar == C.Element {
    replaceSubrange(subrange, with: UnicodeText(newElements))
  }
}
