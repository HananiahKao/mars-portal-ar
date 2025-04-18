// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "MarsPortal",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "MarsPortal",
            targets: ["MarsPortal"]
        )
    ],
    targets: [
        .target(
            name: "MarsPortal"
        )
    ]
)