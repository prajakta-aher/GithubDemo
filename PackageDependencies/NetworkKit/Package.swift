// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "NetworkKitInterface",
            targets: ["NetworkKitInterface"]
        ),
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]
        ),
        .library(
            name: "NetworkKitMocks",
            targets: ["NetworkKitMocks"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkKitInterface"
        ),
        .target(
            name: "NetworkKit",
            dependencies: ["NetworkKitInterface"]
        ),
        .target(
            name: "NetworkKitMocks",
            dependencies: ["NetworkKitInterface"],
            resources: [.process("MockResponses.json")]
        ),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKitInterface", "NetworkKit", "NetworkKitMocks"]
        ),
    ]
)
