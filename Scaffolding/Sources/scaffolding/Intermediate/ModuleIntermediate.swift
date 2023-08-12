import SDGLogic
import SDGText

struct ModuleIntermediate {
  var identifierMapping: [StrictString: StrictString] = [:]
  var things: [StrictString: Thing] = [:]
}

extension ModuleIntermediate {

  func lookupThing(_ identifier: StrictString) -> Thing? {
    return identifierMapping[identifier].flatMap { things[$0] }
  }

  func lookupDeclaration(_ identifier: StrictString) -> ParsedDeclaration? {
    if let thing = lookupThing(identifier)?.declaration {
      return .thing(thing)
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
            let conflicting = lookupThing(name)
            throw ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!])
          }
          identifierMapping[name] = identifier
        }
        things[identifier] = thing
      case .action:
        break
      }
    }
  }
}
