// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Saying",
  products: [
    .library(name: "Saying", targets: ["Saying"]),
  ],
  targets: [
    .target(name: "Saying"),
  ]
)
