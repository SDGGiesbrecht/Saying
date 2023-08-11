import SDGText

extension Node {

  struct Child {
    let name: StrictString
    let type: StrictString
    let kind: Kind
  }
}

extension Node.Child {

  var uppercasedName: StrictString {
    var result = name
    let first = result.removeFirst()
    result.prepend(contentsOf: first.properties.titlecaseMapping.scalars)
    return result
  }
}
