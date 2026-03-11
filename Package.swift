// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "AStar",
  products: [
    .library(name: "AStar", targets: ["AStar"]),
  ],
  dependencies: [
    .package(url: "https://github.com/bradhowes/PriorityQueue", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "AStar",
      dependencies: [
        .product(name: "PriorityQueue", package: "PriorityQueue")
      ]
    ),
    .testTarget(
      name: "AStarTests",
      dependencies: ["AStar"]
    ),
  ]
)
