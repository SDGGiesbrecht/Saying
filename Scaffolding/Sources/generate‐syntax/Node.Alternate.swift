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
    return "\(first.properties.titlecaseMapping)\(result)"
  }
}
