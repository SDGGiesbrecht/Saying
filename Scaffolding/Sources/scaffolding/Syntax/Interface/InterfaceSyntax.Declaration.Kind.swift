extension InterfaceSyntax.Declaration {

  enum Kind {
    case thing(InterfaceSyntax.ThingDeclaration)
    case action(InterfaceSyntax.ActionDeclaration)
  }
}
