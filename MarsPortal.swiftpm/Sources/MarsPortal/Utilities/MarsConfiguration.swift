import Foundation
import SwiftUI

class MarsConfiguration: ObservableObject {
    @Published var showScientificStations: Bool = true
    @Published var showAstronauts: Bool = true
    @Published var animateAstronauts: Bool = true
    @Published var showStationEffects: Bool = true
    @Published var lightIntensity: Float = 1500  // Base lighting intensity
    @Published var dustIntensity: Float = 0.5    // Intensity of dust particles
    @Published var atmosphereOpacity: Float = 0.3 // Opacity of atmosphere effects
    
    init() {
        // Default configuration
    }
    
    // Apply a preset configuration
    func applyPreset(_ preset: MarsPreset) {
        switch preset {
        case .day:
            lightIntensity = 2000
            atmosphereOpacity = 0.2
            dustIntensity = 0.3
            
        case .dusk:
            lightIntensity = 1000
            atmosphereOpacity = 0.5
            dustIntensity = 0.4
            
        case .night:
            lightIntensity = 300
            atmosphereOpacity = 0.1
            dustIntensity = 0.2
            
        case .dustStorm:
            lightIntensity = 800
            atmosphereOpacity = 0.8
            dustIntensity = 1.0
        }
    }
}

enum MarsPreset: String, CaseIterable, Identifiable {
    case day = "Martian Day"
    case dusk = "Martian Dusk"
    case night = "Martian Night"
    case dustStorm = "Dust Storm"
    
    var id: String { rawValue }
}
