import SwiftUI
import ARKit
import RealityKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedEntity: InteractiveEntity?
    var marsConfig: MarsConfiguration
    
    //private var cancellables = Set<AnyCancellable>()
    
    func makeUIView(context: Context) -> MarsARView {
        let arView = MarsARView(frame: .zero, configuration: marsConfig)
        
        // Configure the AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        // Enable people occlusion if device supports it
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        // Enable realistic lighting if supported
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        
        // Subscribe to tap gestures
        for anchor in arView.scene.anchors {
            if let modelEntity = anchor as? ( any HasCollision) {
                modelEntity.generateCollisionShapes(recursive: true)
                arView.installGestures(.all, for: modelEntity)
            }
        }
        // Set up entity selection
        context.coordinator.arView = arView
        arView.selectionHandler = { entity in
            if let interactiveEntity = entity as? InteractiveEntity {
                selectedEntity = interactiveEntity
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: MarsARView, context: Context) {
        // Update AR view with any configuration changes
        uiView.updateConfiguration(marsConfig)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        var arView: MarsARView?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
    }
}
