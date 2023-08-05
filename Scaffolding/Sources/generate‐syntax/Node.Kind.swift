extension Node {

  enum Kind {
    case fixedLeaf(Unicode.Scalar)
    case variableLeaf(allowed: Set<Unicode.Scalar>)
  }
}
