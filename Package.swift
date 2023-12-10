// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpectreKit",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SpectreKit",
            targets: ["SpectreKit"]),
        .executable(
            name: "Example",
            targets: ["Example"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SpectreKit"),
        .testTarget(
            name: "SpectreKitTests",
            dependencies: ["SpectreKit"]),
        .executableTarget(
            name: "Example",
            dependencies: ["SpectreKit"]),
    ]
)
