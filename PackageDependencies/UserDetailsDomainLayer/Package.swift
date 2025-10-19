// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDetailsDomainLayer",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "UserDetailsDomainLayerInterface",
            targets: ["UserDetailsDomainLayerInterface"]
        ),
        .library(
            name: "UserDetailsDomainLayer",
            targets: ["UserDetailsDomainLayer"]
        ),
        .library(
            name: "UserDetailsDomainLayerMocks",
            targets: ["UserDetailsDomainLayerMocks"]
        ),
    ],
    dependencies: [
        .package(path: "../NetworkKit"),
    ],
    targets: [
        .target(
            name: "UserDetailsDomainLayerInterface"
        ),
        .target(
            name: "UserDetailsDomainLayer",
            dependencies: [
                "UserDetailsDomainLayerInterface",
                .product(name: "NetworkKitInterface", package: "NetworkKit")
            ]
        ),
        .target(
            name: "UserDetailsDomainLayerMocks",
            dependencies: ["UserDetailsDomainLayerInterface"]
        ),
        .testTarget(
            name: "UserDetailsDomainLayerTests",
            dependencies: [
                "UserDetailsDomainLayerInterface",
                "UserDetailsDomainLayer",
                .product(name: "NetworkKitMocks", package: "NetworkKit")
            ]
        ),
    ]
)
