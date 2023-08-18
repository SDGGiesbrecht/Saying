import SDGText

struct ActionUse {
  var actionName: StrictString
  var arguments: [ActionUse]
}

extension ActionUse {

  init(_ use: ParsedAction) {
    actionName = use.name()
    switch use {
    case .compound(let compound):
      arguments = compound.arguments.arguments.map { ActionUse($0.argument) }
    case .simple:
      arguments = []
    }
  }
}
