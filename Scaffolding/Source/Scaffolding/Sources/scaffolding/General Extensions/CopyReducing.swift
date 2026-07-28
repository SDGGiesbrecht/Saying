struct CopyReducing<Value> {

  private var reference: Reference<Value>

  init(_ value: Value) {
    reference = Reference(value)
  }

  var value: Value {
    get {
      return reference.value
    }
    set {
      if !isKnownUniquelyReferenced(&reference) {
        reference = Reference(newValue)
        return
      }
      reference.value = newValue
    }
  }
}
