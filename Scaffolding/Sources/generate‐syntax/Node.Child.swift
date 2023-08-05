extension Node {

  enum Kind {
    case fixedLeaf(Unicode.Scalar)
    case variableLeaf
  }
}
