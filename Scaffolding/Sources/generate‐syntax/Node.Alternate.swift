import SDGText

extension Node {

  struct Alternate {
    let name: StrictString
    let type: StrictString
  }
}

extension Node.Alternate {

  var uppercasedName: StrictString {
    var result = name
    let first = result.removeFirst()
    result.prepend(contentsOf: first.properties.titlecaseMapping.scalars)
    return result
  }
}
