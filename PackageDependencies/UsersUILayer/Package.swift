// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UsersUILayer",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "UsersUILayer",
            targets: ["UsersUILayer"]),
    ],
    dependencies: [
        .package(path: "../UserDetailsDomainLayer"),
        .package(path: "../UIUtilities")
    ],
    targets: [
        .target(
            name: "UsersUILayer",
            dependencies: [
                .product(
                    name: "UserDetailsDomainLayerInterface",
                    package: "UserDetailsDomainLayer"
                ),
                .product(
                    name: "UIUtilities",
                    package: "UIUtilities"
                )
            ]
        ),
        .testTarget(
            name: "UsersUILayerTests",
            dependencies: [
                "UsersUILayer",
                .product(
                    name: "UserDetailsDomainLayerInterface",
                    package: "UserDetailsDomainLayer"
                ),
                .product(
                    name: "UserDetailsDomainLayerMocks",
                    package: "UserDetailsDomainLayer"
                )
            ]
        ),
    ]
)
