extension Array where Element == Node.Child {

  var guaranteedNonEmpty: Bool {
    return contains(where: { $0.kind.guaranteedNonEmpty })
  }
}
