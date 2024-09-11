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
      let namespace: [Set<StrictString>]
      switch declaration {
      case .thing(let thingNode):
        documentation = thingNode.documentation
        parameters = []
        let thing = try Thing.construct(thingNode).get()
        namespace = [thing.names]
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
        namespace = [action.names]
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
        var testIndex = 1
        for element in documentation.documentation.entries.entries {
          switch element {
          case .parameter(let parameter):
            if parameter.name.identifierText() ∉ parameters {
              throw ConstructionError.parameterNotFound(parameter)
            }
          case .test(let test):
            tests.append(TestIntermediate(test, location: namespace, index: testIndex))
            testIndex += 1
          case .paragraph:
            break
          }
        }
      }
    }
  }

  mutating func addMagicSymbols() {
    identifierMapping["verify ()"] = "verify ()"
    actions["verify ()"] = ActionIntermediate(
      names: ["verify ()"],
      parameters: [ParameterIntermediate(names: ["condition"], type: "truth value")],
      reorderings: ["verify ()": [0]],
      cSharp: CSharpImplementation(reordering: [0], textComponents: ["Assert(", ")"]),
      javaScript: JavaScriptImplementation(reordering: [0], textComponents: ["console.assert(", ")"]),
      swift: SwiftImplementation(reordering: [0], textComponents: ["assert(", ")"]),
      declaration: nil
    )
    identifierMapping["() is ()"] = "() is ()"
    actions["() is ()"] = ActionIntermediate(
      names: ["() is ()"],
      parameters: [
        ParameterIntermediate(names: ["a"], type: "truth value"),
        ParameterIntermediate(names: ["b"], type: "truth value")
      ],
      reorderings: ["() is ()": [0, 1]],
      returnValue: "truth value",
      cSharp: CSharpImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"]),
      javaScript: JavaScriptImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"]),
      swift: SwiftImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"]),
      declaration: nil
    )
    identifierMapping["true"] = "true"
    actions["true"] = ActionIntermediate(
      names: ["true"],
      parameters: [],
      reorderings: ["true": []],
      returnValue: "truth value",
      cSharp: CSharpImplementation(reordering: [], textComponents: ["true"]),
      javaScript: JavaScriptImplementation(reordering: [], textComponents: ["true"]),
      swift: SwiftImplementation(reordering: [], textComponents: ["true"]),
      declaration: nil
    )
    identifierMapping["false"] = "false"
    actions["false"] = ActionIntermediate(
      names: ["false"],
      parameters: [],
      reorderings: ["false": []],
      returnValue: "truth value",
      cSharp: CSharpImplementation(reordering: [], textComponents: ["false"]),
      javaScript: JavaScriptImplementation(reordering: [], textComponents: ["false"]),
      swift: SwiftImplementation(reordering: [], textComponents: ["false"]),
      declaration: nil
    )
  }

  func validateReferences() throws {
    var errors: [ReferenceError] = []
    for action in actions {
      action.value.validateReferences(module: self, errors: &errors)
    }
    for test in tests {
      test.action.validateReferences(module: self, errors: &errors)
    }
    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }
}
