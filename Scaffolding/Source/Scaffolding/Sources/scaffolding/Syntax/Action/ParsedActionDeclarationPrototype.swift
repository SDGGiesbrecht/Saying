protocol ParsedActionDeclarationPrototype: ParsedActionPrototype {
  var implementation: ParsedActionImplementations { get }
}

extension ParsedActionDeclaration: ParsedActionDeclarationPrototype {
}
extension ParsedChoiceDeclaration: ParsedActionDeclarationPrototype {
}
