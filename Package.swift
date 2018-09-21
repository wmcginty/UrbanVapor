// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "UrbanVapor",
    products: [
        .library(name: "UrbanVapor", targets: ["UrbanVapor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.2"),
    ],
    targets: [
        .target(name: "UrbanVapor", dependencies: ["Vapor"], path: "Sources/"),
        .testTarget(name: "UrbanVaporTests", dependencies: ["UrbanVapor"])
    ]
)
