import RealityKit
import Foundation

// Base protocol for all interactive entities in the Mars environment
protocol InteractiveEntity: Entity {
    var name: String { get }
    var description: String { get }
    var detailImage: String? { get }
    var isInteractive: Bool { get }
    
    func interact()
}

// Default implementation for interactive entities
extension InteractiveEntity {
    var isInteractive: Bool { true }
    var detailImage: String? { nil }
    
    func interact() {
        // Default interaction behavior - simple animation
        let originalScale = self.scale
        let targetScale = originalScale * 1.2
        
        // Create a pulse animation
        self.transform.scale = targetScale
        
        // Animate back to original scale
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.transform.scale = originalScale
            }
        }
    }
}
