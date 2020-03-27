// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "UrbanVapor",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "UrbanVapor", targets: ["UrbanVapor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
    ],
    targets: [
        .target(name: "UrbanVapor", dependencies: [
            .product(name: "Vapor", package: "vapor")
        ], path: "Sources/"),
        .testTarget(name: "UrbanVaporTests", dependencies: ["UrbanVapor"])
    ]
)
