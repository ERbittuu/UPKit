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
    dependencies: [
        // Adding the Shift library dependency up to the next major version
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.1"))
    ],
    targets: [
        // Main target for UPKit
        .target(
            name: "UPKit",
            dependencies: [
                // Linking the Shift library to the UPKit target
                .product(name: "SnapKit", package: "SnapKit")
            ]
        )
    ]
)
