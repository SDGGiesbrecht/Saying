// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "scaffolding",
  dependencies: [
    .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: Version(10, 1, 3))
  ],
  targets: [
    .executableTarget(
      name: "scaffolding",
      dependencies: [
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
      ]
    ),
  ]
)
