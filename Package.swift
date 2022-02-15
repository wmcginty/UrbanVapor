// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "urbanvapor",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "UrbanVapor", targets: ["UrbanVapor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.54.0"),
    ],
    targets: [
        .target(name: "UrbanVapor", dependencies: [.product(name: "Vapor", package: "vapor")], path: "Sources"),
        .testTarget(name: "UrbanVaporTests", dependencies: ["UrbanVapor"], path: "Tests")
    ]
)
