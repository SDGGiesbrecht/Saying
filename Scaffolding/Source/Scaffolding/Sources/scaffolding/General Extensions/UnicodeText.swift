import Saying

extension UnicodeText {

  public init<Scalars>(_ scalars: Scalars) where Scalars : Sequence, Scalars.Element == Unicode.Scalar {
    if let text = scalars as? UnicodeText {
      self.init(text)
    } else if let slice = scalars as? Slice<UnicodeText> {
      self.init(slice)
    } else if let sliceOfSegments = scalars as? Slice<UnicodeSegments> {
      self.init(sliceOfSegments)
    } else {
      self.init(String.UnicodeScalarView(scalars))
    }
  }

  init(_ string: String) {
    self.init(string.unicodeScalars)
  }

  init(_ scalar: Unicode.Scalar) {
    self.init(String(scalar))
  }
}

extension UnicodeText: CustomStringConvertible {

  public var description: String {
    return String(self)
  }
}

extension UnicodeText: ExpressibleByStringInterpolation {}

extension UnicodeText: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self.init(value)
  }
}

extension UnicodeText: RangeReplaceableCollection {

  public init() {
    self = ""
  }

  public mutating func replaceSubrange<C>(_ subrange: Range<String.UnicodeScalarView.Index>, with newElements: C)
  where C : Collection, Unicode.Scalar == C.Element {
    replaceSubrange(subrange, with: UnicodeText(newElements))
  }
}
