// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "urbanvapor",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "UrbanVapor", targets: ["UrbanVapor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "UrbanVapor", dependencies: [
            .product(name: "Vapor", package: "vapor")
        ], path: "Sources/"),
        .testTarget(name: "UrbanVaporTests", dependencies: ["UrbanVapor"])
    ]
)
