import SDGLogic
import SDGCollections
import SDGText

struct Token {

  init?(source: StrictString, kind: Kind) {
    let allowed = kind.allowedCharacters
    guard source.allSatisfy({ allowed.contains($0) }),
      ¬kind.isSingleScalar ∨ source.count == 1 else {
      return nil
    }
    self.kind = kind
    self.source = source
  }

  init(error: Unicode.Scalar) {
    self.kind = .error
    self.source = StrictString(error)
  }

  let kind: Kind
  let source: StrictString
}
