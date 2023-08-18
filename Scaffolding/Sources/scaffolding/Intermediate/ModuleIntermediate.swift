import SDGLogic
import SDGText

struct ModuleIntermediate {
  var identifierMapping: [StrictString: StrictString] = [:]
  var things: [StrictString: Thing] = [:]
  var actions: [StrictString: ActionIntermediate] = [:]
}

extension ModuleIntermediate {

  func lookupThing(_ identifier: StrictString) -> Thing? {
    return identifierMapping[identifier].flatMap { things[$0] }
  }

  func lookupAction(_ identifier: StrictString) -> ActionIntermediate? {
    return identifierMapping[identifier].flatMap { actions[$0] }
  }

  func lookupDeclaration(_ identifier: StrictString) -> ParsedDeclaration? {
    if let thing = lookupThing(identifier)?.declaration {
      return .thing(thing)
    } else if let action = lookupAction(identifier)?.declaration {
      return .action(action)
    } else {
      return nil
    }
  }

  mutating func add(file: ParsedDeclarationList) throws {
    for declaration in file.declarations {
      switch declaration {
      case .thing(let thingNode):
        let thing = Thing(thingNode)
        let identifier = thing.names.identifier()
        for name in thing.names {
          if identifierMapping[name] ≠ nil {
            throw ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!])
          }
          identifierMapping[name] = identifier
        }
        things[identifier] = thing
      case .action(let actionNode):
        let action = try ActionIntermediate.construct(actionNode).get()
        let identifier = action.names.identifier()
        for name in action.names {
          if identifierMapping[name] ≠ nil {
            throw ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!])
          }
          identifierMapping[name] = identifier
        }
        actions[identifier] = action
      }
    }
  }
}
