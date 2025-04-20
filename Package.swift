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
            name: "Mars Portal",
            targets: ["MarsPortal"],
            bundleIdentifier: "com.hananiah.mars-portal",
            teamIdentifier: "HANANIAH",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .palette),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft
            ]
        )
        
    ],
    targets: [
        .executableTarget(
            name: "MarsPortal",
            dependencies: [],
            resources: [.process("Resources")]
        )
    ]
)
