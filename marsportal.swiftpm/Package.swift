// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MarsPortal",
    platforms: [.iOS(.v15)],
    products: [
        .executable(name: "MarsPortal", targets: ["MarsPortal"])
    ],
    targets: [
        .executableTarget(
            name: "MarsPortal",
            path: "Sources/MarsPortal"
        )
    ]
)
