# Mars Portal AR

An immersive iPadOS Augmented Reality (AR) application that transforms your space into a virtual Martian landscape, offering an interactive exploration of the Red Planet.

## Features

- AR portal to Mars environment
- Realistic 3D models of Martian terrain, scientific station, and astronaut
- Interactive AR entities with gesture recognition
- Custom AR materials and lighting for realistic Mars environment
- Control panel for managing AR scene
- Object information display for educational content

## Technical Details

- Swift 5.5+
- iOS/iPadOS 15.0+
- Frameworks: SwiftUI, RealityKit, ARKit
- 3D model format: USDZ

## Setup and Installation

1. Clone the repository
2. Open the project in Xcode
3. Select an iOS device with LiDAR capabilities (iPad Pro or iPhone Pro)
4. Build and run the application

## Requirements

- iOS/iPadOS 15.0 or later
- Device with LiDAR sensor (iPad Pro 2020 or newer, iPhone 12 Pro or newer)

## Project Structure

```
MarsPortal/
├── Package.swift              # Swift Package manifest
├── Sources/
│   └── MarsPortal/            # Main application source code
│       ├── MarsPortalApp.swift       # App entry point
│       ├── ContentView.swift         # Main view
│       ├── ARViewContainer.swift     # AR view container
│       ├── MarsARView.swift          # Custom AR view
│       ├── Models/                   # Data models
│       │   ├── Astronaut.swift
│       │   ├── InteractiveEntity.swift
│       │   └── ScientificStation.swift
│       ├── Views/                    # UI components
│       │   ├── ControlPanel.swift
│       │   └── ObjectInfoView.swift
│       ├── Utilities/                # Helper classes
│       │   ├── MarsConfiguration.swift
│       │   └── PortalMaterial.swift
│       └── Resources/                # 3D models and assets
│           ├── astronaut.usdz
│           ├── mars_terrain.usdz
│           └── station.usdz
```

## License

See the LICENSE file for details.