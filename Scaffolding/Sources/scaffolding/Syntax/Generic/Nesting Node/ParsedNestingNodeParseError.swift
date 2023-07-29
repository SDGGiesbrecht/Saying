enum ParsedNestingNodeParseError<Leaf>: Error {
case unpairedElement(Leaf)
}
