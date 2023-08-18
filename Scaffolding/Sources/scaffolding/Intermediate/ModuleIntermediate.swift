import SDGLogic
import SDGCollections
import SDGText

struct ModuleIntermediate {
  var identifierMapping: [StrictString: StrictString] = [:]
  var things: [StrictString: Thing] = [:]
  var actions: [StrictString: ActionIntermediate] = [:]
  var tests: [TestIntermediate] = []
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
      let documentation: ParsedAttachedDocumentation?
      let parameters: Set<StrictString>
      switch declaration {
      case .thing(let thingNode):
        documentation = thingNode.documentation
        parameters = []
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
        documentation = actionNode.documentation
        let action = try ActionIntermediate.construct(actionNode).get()
        parameters = action.parameters.reduce(Set(), { $0 ∪ $1.names })
        let identifier = action.names.identifier()
        for name in action.names {
          if identifierMapping[name] ≠ nil {
            throw ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!])
          }
          identifierMapping[name] = identifier
        }
        actions[identifier] = action
      }
      if let documentation = documentation {
        for element in documentation.documentation.entries.entries {
          switch element {
          case .parameter(let parameter):
            if parameter.name.identifierText() ∉ parameters {
              throw ConstructionError.parameterNotFound(parameter)
            }
          case .test(let test):
            tests.append(TestIntermediate(test))
          case .paragraph:
            break
          }
        }
      }
    }
  }
}
