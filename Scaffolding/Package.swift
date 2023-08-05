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
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGMathematics", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
      ],
      plugins: [
        .plugin(name: "GenerateSyntax")
      ]
    ),
    .plugin(
      name: "GenerateSyntax",
      capability: .buildTool(),
      dependencies: [
        "generate‐syntax"
      ]
    ),
    .executableTarget(
      name: "generate‐syntax",
      dependencies: [
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
      ]
    )
  ]
)
