import RealityKit
import UIKit

struct PortalMaterial {
    
    static func createPortalFrameMaterial() -> Material {
        print(#function)
        var material = SimpleMaterial(color: .darkGray, roughness: 0.5, isMetallic: true)
        material.metallic = MaterialScalarParameter(floatLiteral: 0.8)
        return material
    }
    
    static func createPortalDoorMaterial() -> Material {
        print(#function)
        // Create a material that lets us see through to the Mars environment
        // but occludes from the outside
        let material = OcclusionMaterial()
        
        // This will allow us to see through from one side but not the other
        //material.opacity = MaterialScalarParameter(floatLiteral: 0.01)
        
        return material
    }
    
    static func createMarsTerrainMaterial() -> Material {
        print(#function)
        // Create a procedural material that looks like Mars terrain
        var material = SimpleMaterial()
        
        // Mars reddish-orange color
        material.color = SimpleMaterial.BaseColor.init(tint: .init(red: 0.76, green: 0.38, blue: 0.18, alpha: 1.0), texture: .none) 
        
        // Make the surface rough like regolith
        material.roughness = MaterialScalarParameter(floatLiteral: 0.9)
        
        // Add some metallic quality for iron oxide
        material.metallic = MaterialScalarParameter(floatLiteral: 0.1)
        
        return material
    }
    
    static func createMarsSkyMaterial() -> Material {
        print(#function)
        // Create a material for the sky dome, Should be unlit material
        var material = UnlitMaterial()
        
        // Mars skybox would be a dusty pale orange
        material.color.tint = .init(red: 0.85, green: 0.60, blue: 0.40, alpha: 1.0)
        
        // Non-metallic sky
        //material.metallic = MaterialScalarParameter(floatLiteral: 0.0)
        
        // Smooth sky material
        //material.roughness = MaterialScalarParameter(floatLiteral: 0.0)
        
        
        return material
    }
}
