extension Node {

  struct Child {
    let name: String
    let type: String
    let kind: Kind
  }
}

extension Node.Child {

  var uppercasedName: String {
    var result = name
    let first = result.unicodeScalars.removeFirst()
    return "\(first.properties.titlecaseMapping)\(result)"
  }
}
