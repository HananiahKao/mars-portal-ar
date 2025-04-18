# Mars Portal AR

An immersive iPadOS Augmented Reality (AR) application that transforms your space into a virtual Martian landscape, offering an interactive exploration of the Red Planet.

## Features

- Augmented Reality portal to Mars environment
- Interactive 3D models of astronauts and scientific stations
- Realistic Martian terrain with ambient effects
- Touch interactions with virtual objects
- Dynamic lighting and atmospheric effects

## Technical Details

- Built with Swift and SwiftUI
- Uses RealityKit for 3D rendering
- ARKit for augmented reality capabilities
- USDZ 3D model integration
- Designed for iPadOS 15+ with LiDAR sensors

## Requirements

- iPad with LiDAR sensor (iPad Pro 2020 or newer, iPad Air 4th gen or newer)
- iPadOS 15 or later
- Xcode 13 or later (for development)

## Installation

1. Clone this repository
2. Open the project in Xcode or Swift Playgrounds
3. Build and run on a compatible iPad device

## Usage

1. Launch the app and point your iPad at a horizontal surface
2. Tap to place the Mars portal
3. Look through the portal to see the Martian landscape
4. Tap on astronauts or stations to interact with them
5. Use the control panel to customize your view

## Development

This project is structured as a Swift Package with RealityKit and ARKit dependencies. The 3D models are stored as USDZ files and are loaded at runtime.

### Project Structure

- `Sources/MarsPortal/` - Main application code
  - `Models/` - Interactive entity models
  - `Views/` - SwiftUI views for UI
  - `Utilities/` - Helper functions and configurations
- `Resources/` - 3D models and assets

## License

MIT License