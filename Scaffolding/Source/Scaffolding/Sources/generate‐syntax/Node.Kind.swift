extension Node {

  enum Kind {
    case fixedLeaf
    case keyword(Set<String>)
    case variableLeaf(allowed: Set<Unicode.Scalar>)
    case compound(children: [Node.Child])
    case alternates([Node.Alternate])
  }
}
