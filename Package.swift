// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "MarsPortal",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .executable(
            name: "MarsPortal",
            targets: ["MarsPortal"]
        )
    ],
    targets: [
        .executableTarget(
            name: "MarsPortal",
            dependencies: []
        )
    ]
)
