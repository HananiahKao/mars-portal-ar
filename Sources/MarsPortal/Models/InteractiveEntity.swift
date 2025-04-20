import RealityKit
import Foundation

// Base protocol for all interactive entities in the Mars environment
class InteractiveEntity: Entity {

    required init(name: String, description: String) {
        self.description = description
        self.isInteractive = true
    }

    required init() {
        fatalError("init() has not been implemented")
    }
    var description: String 
    var detailImage: String? 
    var isInteractive: Bool 
    
    
    func interact() {
        // Default interaction behavior - simple animation
        let originalScale = self.scale
        let targetScale = originalScale * 1.2
        
        // Create a pulse animation
        // Instantly scale up
        self.transform.scale = targetScale
        
        // Animate back to original scale after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let newTransform = Transform(
                scale: originalScale,
                rotation: self.transform.rotation,
                translation: self.transform.translation
            )
            
            self.move(to: newTransform, relativeTo: self.parent, duration: 0.5, timingFunction: .easeInOut)
        }
    }
}
