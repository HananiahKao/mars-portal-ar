
// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "MarsPortal",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MarsPortal",
            targets: ["MarsPortal"]
        ),
        .executable(
            name: "MarsPortalApp",
            targets: ["MarsPortal"]
        )
    ],
    targets: [
        .target(
            name: "MarsPortal",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .executableTarget(
            name: "MarsPortalApp",
            dependencies: ["MarsPortal"]
        )
    ]
)
