import RealityKit
import Foundation

class Astronaut: InteractiveEntity {
    required init(name: String, description: String) {
         print(#function)
        super.init(name: name, description: description)
        
        self.name = name
        self.description = description
        
        // Try to load astronaut model
        do {
            let astronautModel = try ModelEntity.load(named: "astronaut")
            self.addChild(astronautModel)
        } catch {
            print("Failed to load astronaut model: \(error.localizedDescription)")
            // Create a fallback model
            createFallbackModel()
        }
        
        // Add a collision component for tap detection
        //TODO: check if that is necessary with ARViewContainer line 35's "arView.installGestures(.all, for: modelEntity)"
        //self.collision = CollisionComponent(shapes: [.generateCapsule(height: 1.8, radius: 0.3)])
    }
    
    required init() {
        super.init(name: "Unknown Astronaut", description: "Mars astronaut")
        self.name = "Unknown Astronaut"
        self.description = "Mars astronaut"
        createFallbackModel()
    }
    
    private func createFallbackModel() {
        print(#function)
        // Create a simple geometric representation of an astronaut
        // Body - white spacesuit
        let body = ModelEntity(
            mesh: .generateBox(width: 0.5, height: 1.0, depth: 0.5, cornerRadius: 0.3),
            materials: [SimpleMaterial(color: .white, isMetallic: false)]
        )
        
        // Head - helmet
        let helmet = ModelEntity(
            mesh: .generateSphere(radius: 0.25),
            materials: [SimpleMaterial(color: .init(red: 0.9, green: 0.9, blue: 1.0, alpha: 0.8), isMetallic: true)]
        )
        helmet.position = [0, 0.6, 0]
        
        // Arms
        let leftArm = ModelEntity(
            mesh: .generateBox(width: 0.1, height: 0.6, depth: 0.1, cornerRadius: 0.1),
            materials: [SimpleMaterial(color: .white, isMetallic: false)]
        )
        leftArm.position = [-0.3, 0.1, 0]
        leftArm.orientation = simd_quatf(angle: -.pi/6, axis: [0, 0, 1])
        
        let rightArm = ModelEntity(
            mesh: .generateBox(width: 0.1, height: 0.6, depth: 0.1, cornerRadius: 0.1),
            materials: [SimpleMaterial(color: .white, isMetallic: false)]
        )
        rightArm.position = [0.3, 0.1, 0]
        rightArm.orientation = simd_quatf(angle: .pi/6, axis: [0, 0, 1])
        
        // Legs
        let leftLeg = ModelEntity(
            mesh: .generateBox(width: 0.2, height: 0.7, depth: 0.2, cornerRadius: 0.12),
            materials: [SimpleMaterial(color: .white, isMetallic: false)]
        )
        leftLeg.position = [-0.15, -0.5, 0]
        
        let rightLeg = ModelEntity(
            mesh: .generateBox(width: 0.2, height: 0.7, depth: 0.2, cornerRadius: 0.12),
            materials: [SimpleMaterial(color: .white, isMetallic: false)]
        )
        rightLeg.position = [0.15, -0.5, 0]
        
        // Backpack
        let backpack = ModelEntity(
            mesh: .generateBox(width: 0.4, height: 0.5, depth: 0.2),
            materials: [SimpleMaterial(color: .lightGray, isMetallic: true)]
        )
        backpack.position = [0, 0.1, -0.2]
        
        // Assemble the astronaut
        body.addChild(helmet)
        body.addChild(leftArm)
        body.addChild(rightArm)
        body.addChild(leftLeg)
        body.addChild(rightLeg)
        body.addChild(backpack)
        
        self.addChild(body)
    }
    
    override func interact() {
        super.interact()
        
        // Make the astronaut wave
        if let leftArm = self.findEntity(named: "leftArm") {
            // Save original transform
            let originalOrientation = leftArm.orientation
            let originalTransform = Transform(rotation: originalOrientation, translation: leftArm.transform.translation)
            // Wave animation
            let waveUp = simd_quatf(angle: -.pi/2, axis: [0, 0, 1])
            let waveUpTransform = Transform(rotation: waveUp, translation: leftArm.transform.translation)
            
            leftArm.move(to: waveUpTransform, relativeTo: leftArm.parent, duration: 0.5)
            // Return to original position
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                leftArm.move(to: originalTransform, relativeTo: leftArm.parent, duration: 0.5)
            }
        } else {
            // If we're using the fallback model, animate the whole astronaut
            let originalPosition = self.transform.translation
            let jumpHeight: Float = 0.2
            let originalTransform = Transform(rotation: self.orientation, translation: originalPosition)
            let jumpHightestTransform = Transform(rotation: self.orientation, translation: [originalPosition.x, originalPosition.y + jumpHeight, originalPosition.z])
            // Jump animation
            self.move(to: jumpHightestTransform, relativeTo: self.parent, duration: 0.3)
            
            // Return to original position
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.move(to: originalTransform, relativeTo: self.parent, duration: 0.3)
            }
        }
    }
}
