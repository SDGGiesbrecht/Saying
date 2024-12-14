// swift-tools-version: 5.7

import PackageDescription

// This package does nothing. It only helps IDEs see the source files in this directory while editing the Scaffolding package.
let package = Package(
  name: "Source",
  products: [
    .library(name: "Source", targets: ["Source"])
  ],
  targets: [
    .target(name: "Source", path: ".", sources: ["Empty.swift"])
  ]
)
