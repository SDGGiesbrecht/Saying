import SDGText

struct Parsed<T> {
  let node: T
  let location: Slice<StrictString>
}
