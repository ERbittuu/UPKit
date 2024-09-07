// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UPKit",
    platforms: [
        .iOS(.v13) // Targeting iOS 13
    ],
    products: [
        // Defines the library product visible to other packages
        .library(
            name: "UPKit",
            targets: ["UPKit"]
        ),
    ],
    dependencies: [],
    targets: [
        // Main target for UPKit
        .target(
            name: "UPKit",
            dependencies: []
        ),
    ]
)
