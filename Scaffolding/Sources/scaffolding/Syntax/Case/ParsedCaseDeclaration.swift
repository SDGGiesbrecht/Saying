extension ParsedCaseDeclaration {
  var contents: ParsedRequirementReturnValue? {
    return details.flatMap { detailNode in
      switch detailNode {
      case .contents(let contents):
        return contents
      case .implementation:
        return nil
      case .dual(let dual):
        return dual.contents
      }
    }
  }
  var implementation: ParsedCaseImplementations? {
    return nil
    #warning("Not implemented yet.")
    /*return details.flatMap { detailNode in
      switch detailNode {
      case .contents:
        return nil
      case .implementation(let implementation):
        return implementation
      case .dual(let dual):
        return dual.implementation
      }
    }*/
  }
}
