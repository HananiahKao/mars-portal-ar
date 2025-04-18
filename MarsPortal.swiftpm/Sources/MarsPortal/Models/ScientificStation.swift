import RealityKit
import Foundation

class ScientificStation: Entity, InteractiveEntity {
    var name: String
    var description: String
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
        
        super.init()
        
        // Try to load station model
        do {
            let stationModel = try ModelEntity.load(named: "station")
            self.addChild(stationModel)
        } catch {
            print("Failed to load station model: \(error.localizedDescription)")
            // Create a fallback model
            createFallbackModel()
        }
        
        // Add a collision component for tap detection
        self.collision = CollisionComponent(shapes: [.generateBox(width: 0.5, height: 0.5, depth: 0.5)])
    }
    
    required init() {
        self.name = "Unknown Station"
        self.description = "Scientific research station"
        super.init()
        createFallbackModel()
    }
    
    private func createFallbackModel() {
        // Create a simple geometric representation of a station
        let baseColor: Material
        
        // Different colors for different station types
        if name.contains("Research") {
            baseColor = SimpleMaterial(color: .blue, isMetallic: true)
        } else if name.contains("Communication") {
            baseColor = SimpleMaterial(color: .green, isMetallic: true)
        } else if name.contains("Power") {
            baseColor = SimpleMaterial(color: .yellow, isMetallic: true)
        } else {
            baseColor = SimpleMaterial(color: .gray, isMetallic: true)
        }
        
        // Create base structure
        let base = ModelEntity(mesh: .generateBox(width: 0.5, height: 0.2, depth: 0.5), materials: [baseColor])
        
        // Add a tower or antenna
        let tower = ModelEntity(
            mesh: .generateBox(width: 0.1, height: 0.5, depth: 0.1),
            materials: [SimpleMaterial(color: .lightGray, isMetallic: true)]
        )
        tower.position = [0, 0.35, 0]
        
        // Add solar panels for power station
        if name.contains("Power") {
            let solarPanel1 = ModelEntity(
                mesh: .generatePlane(width: 0.3, height: 0.3),
                materials: [SimpleMaterial(color: .blue, isMetallic: false)]
            )
            solarPanel1.position = [0.3, 0.2, 0]
            solarPanel1.orientation = simd_quatf(angle: .pi/2, axis: [0, 0, 1])
            
            let solarPanel2 = ModelEntity(
                mesh: .generatePlane(width: 0.3, height: 0.3),
                materials: [SimpleMaterial(color: .blue, isMetallic: false)]
            )
            solarPanel2.position = [-0.3, 0.2, 0]
            solarPanel2.orientation = simd_quatf(angle: -.pi/2, axis: [0, 0, 1])
            
            base.addChild(solarPanel1)
            base.addChild(solarPanel2)
        }
        
        // Add a dish for communication center
        if name.contains("Communication") {
            let dish = ModelEntity(
                mesh: .generateBox(width: 0.3, height: 0.05, depth: 0.3),
                materials: [SimpleMaterial(color: .white, isMetallic: false)]
            )
            dish.position = [0, 0.5, 0]
            tower.addChild(dish)
        }
        
        // Add components to the station
        base.addChild(tower)
        self.addChild(base)
    }
    
    override func interact() {
        super.interact()
        
        // Add station-specific interaction animation
        // For example, make the station light up or emit particles
        let originalColor = self.children[0].children[0].model?.materials[0].tintColor
        
        // Change color temporarily
        if var material = self.children[0].children[0].model?.materials[0] as? SimpleMaterial {
            material.tintColor = .white
            self.children[0].children[0].model?.materials = [material]
            
            // Revert back after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let originalColor = originalColor {
                    if var material = self.children[0].children[0].model?.materials[0] as? SimpleMaterial {
                        material.tintColor = originalColor
                        self.children[0].children[0].model?.materials = [material]
                    }
                }
            }
        }
    }
}
