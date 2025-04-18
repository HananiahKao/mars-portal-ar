import RealityKit
import UIKit

struct PortalMaterial {
    
    static func createPortalFrameMaterial() -> Material {
        var material = SimpleMaterial(color: .darkGray, roughness: 0.5, isMetallic: true)
        material.metallic = MaterialScalarParameter(floatLiteral: 0.8)
        return material
    }
    
    static func createPortalDoorMaterial() -> Material {
        // Create a material that lets us see through to the Mars environment
        // but occludes from the outside
        var material = OcclusionMaterial()
        
        // This will allow us to see through from one side but not the other
        material.opacity = MaterialScalarParameter(floatLiteral: 0.01)
        
        return material
    }
    
    static func createMarsTerrainMaterial() -> Material {
        // Create a procedural material that looks like Mars terrain
        var material = SimpleMaterial()
        
        // Mars reddish-orange color
        material.baseColor = MaterialColorParameter.color(.init(red: 0.76, green: 0.38, blue: 0.18, alpha: 1.0))
        
        // Make the surface rough like regolith
        material.roughness = MaterialScalarParameter(floatLiteral: 0.9)
        
        // Add some metallic quality for iron oxide
        material.metallic = MaterialScalarParameter(floatLiteral: 0.1)
        
        return material
    }
    
    static func createMarsSkyMaterial() -> Material {
        // Create a material for the sky dome
        var material = SimpleMaterial()
        
        // Mars skybox would be a dusty pale orange
        material.baseColor = MaterialColorParameter.color(.init(red: 0.85, green: 0.60, blue: 0.40, alpha: 1.0))
        
        // Non-metallic sky
        material.metallic = MaterialScalarParameter(floatLiteral: 0.0)
        
        // Smooth sky material
        material.roughness = MaterialScalarParameter(floatLiteral: 0.0)
        
        // Should be unlit material
        material.lighting = .unlit
        
        return material
    }
}
