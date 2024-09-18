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
    var errors: [ConstructionError] = []
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
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
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
            errors.append(ConstructionError.redeclaredIdentifier(name, [declaration, lookupDeclaration(name)!]))
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
    if ¬errors.isEmpty {
      throw ErrorList(errors)
    }
  }

  mutating func addMagicSymbols() {
    identifierMapping["verify ()"] = "verify ()"
    actions["verify ()"] = ActionIntermediate(
      names: ["verify ()"],
      parameters: [ParameterIntermediate(names: ["condition"], type: "truth value")],
      reorderings: ["verify ()": [0]],
      c: NativeActionImplementation(reordering: [0], textComponents: ["assert(", ")"], requiredImport: "assert"),
      cSharp: NativeActionImplementation(reordering: [0], textComponents: ["Assert(", ")"]),
      javaScript: NativeActionImplementation(reordering: [0], textComponents: ["console.assert(", ")"]),
      kotlin: NativeActionImplementation(reordering: [0], textComponents: ["assert(", ")"]),
      swift: NativeActionImplementation(reordering: [0], textComponents: ["assert(", ")"])
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
      c: NativeActionImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"]),
      cSharp: NativeActionImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"]),
      javaScript: NativeActionImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"]),
      kotlin: NativeActionImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"]),
      swift: NativeActionImplementation(reordering: [0, 1], textComponents: ["(", " == ", ")"])
    )
    identifierMapping["true"] = "true"
    actions["true"] = ActionIntermediate(
      names: ["true"],
      parameters: [],
      reorderings: ["true": []],
      returnValue: "truth value",
      c: NativeActionImplementation(reordering: [], textComponents: ["true"], requiredImport: "stdbool"),
      cSharp: NativeActionImplementation(reordering: [], textComponents: ["true"]),
      javaScript: NativeActionImplementation(reordering: [], textComponents: ["true"]),
      kotlin: NativeActionImplementation(reordering: [], textComponents: ["true"]),
      swift: NativeActionImplementation(reordering: [], textComponents: ["true"])
    )
    identifierMapping["false"] = "false"
    actions["false"] = ActionIntermediate(
      names: ["false"],
      parameters: [],
      reorderings: ["false": []],
      returnValue: "truth value",
      c: NativeActionImplementation(reordering: [], textComponents: ["false"], requiredImport: "stdbool"),
      cSharp: NativeActionImplementation(reordering: [], textComponents: ["false"]),
      javaScript: NativeActionImplementation(reordering: [], textComponents: ["false"]),
      kotlin: NativeActionImplementation(reordering: [], textComponents: ["false"]),
      swift: NativeActionImplementation(reordering: [], textComponents: ["false"])
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

extension ModuleIntermediate {

  func applyingTestCoverageTracking() -> ModuleIntermediate {
    var identifierMapping = self.identifierMapping
    var actions = self.actions
    for (_, action) in self.actions {
      let wrappedIdentifier = action.coverageTrackingIdentifier()
      identifierMapping[wrappedIdentifier] = wrappedIdentifier
      actions[wrappedIdentifier] = action.wrappedToTrackCoverage()
    }
    return ModuleIntermediate(
      identifierMapping: identifierMapping,
      things: things,
      actions: actions,
      tests: tests
    )
  }
}
