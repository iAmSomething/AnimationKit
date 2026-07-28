// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SolarAnimationsKit",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SolarAnimationsKit",
            targets: ["SolarAnimationsKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SolarAnimationsKit"
        ),
        .testTarget(
            name: "SolarAnimationsKitTests",
            dependencies: [
                "SolarAnimationsKit",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
