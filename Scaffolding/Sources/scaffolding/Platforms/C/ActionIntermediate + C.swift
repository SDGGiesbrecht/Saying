import SDGLogic

extension ActionIntermediate {

  func cSignature(module: ModuleIntermediate) -> CSignature {
    return CSignature(
      parameters: parameters.compactMap({ module.lookupThing($0.type)?.c }),
      returnValue: returnValue.flatMap({ module.lookupThing($0)?.c }) ?? "void",
      boolLiteral: c?.textComponents == ["true"] ∨ c?.textComponents == ["false"],
      equals: c?.textComponents == ["(", " == ", ")"],
      and: c?.textComponents == ["(", " && ", ")"],
      assert: c?.textComponents == ["assert(", ")"]
    )
  }
}
