extension Node {

  struct Alternate {
    let name: String
    let type: String
  }
}

extension Node.Alternate {

  var uppercasedName: String {
    var result = name
    let first = result.unicodeScalars.removeFirst()
    result.unicodeScalars.prepend(contentsOf: first.properties.titlecaseMapping.scalars)
    return result
  }
}
