// swift-tools-version: 5.6
import PackageDescription
import AppleProductTypes

let package = Package(
    name: "MarsPortal",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .iOSApplication(
            name: "MarsPortal",
            targets: ["MarsPortal"],
            bundleIdentifier: "com.yourcompany.MarsPortal",
            teamIdentifier: "YOURTEAMID",
            displayVersion: "1.0",
            bundleVersion: "1",
            iconAssetName: "AppIcon",
            accentColorAssetName: "AccentColor"
        )
    ],
    targets: [
        .executableTarget(
            name: "MarsPortal",
            dependencies: []
        )
    ]
)
