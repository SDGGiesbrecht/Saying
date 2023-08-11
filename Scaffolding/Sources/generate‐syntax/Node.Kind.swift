import SDGText

extension Node {

  enum Kind {
    case fixedLeaf(Unicode.Scalar)
    case keyword(Set<StrictString>)
    case variableLeaf(allowed: Set<Unicode.Scalar>)
    case compound(children: [Node.Child])
    case alternates([Node.Alternate])
  }
}
