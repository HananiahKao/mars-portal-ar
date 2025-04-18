import ARKit
import RealityKit
import SwiftUI
import Combine

class MarsARView: ARView {
    var portalAnchor: AnchorEntity?
    var marsScene: Entity?
    var astronauts: [Astronaut] = []
    var stations: [ScientificStation] = []
    var placementAnchor: AnchorEntity?
    var selectionHandler: ((Entity) -> Void)?
    var currentConfiguration: MarsConfiguration!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(frame: CGRect, configuration: MarsConfiguration) {
        super.init(frame: frame)
        currentConfiguration = configuration
        setupMarsScene()
        setupTapGesture()
        
        // Set up coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = self.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(coachingOverlay)
        
        // Set up camera publication
        self.scene.subscribe(to: SceneEvents.Update.self) { [weak self] event in
            guard let self = self else { return }
            self.updateScene(event)
        }.store(in: &cancellables)
    }
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup the Mars scene with portal
    private func setupMarsScene() {
        // Create a placement anchor for the portal
        placementAnchor = AnchorEntity(plane: .horizontal, classification: .floor, minimumBounds: [0.5, 0.5])
        scene.addAnchor(placementAnchor!)
        
        // Add tap gesture to place portal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        // First check if we're tapping on an existing entity
        if let entity = self.entity(at: tapLocation) as? InteractiveEntity {
            selectionHandler?(entity)
            return
        }
        
        // If we haven't placed the portal yet, try to place it where user tapped
        if portalAnchor == nil {
            guard let raycastResult = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal).first else {
                return
            }
            
            createMarsPortal(at: raycastResult.worldTransform)
        }
    }
    
    private func createMarsPortal(at transform: simd_float4x4) {
        // Create a portal anchor at the tap location
        portalAnchor = AnchorEntity(world: transform)
        scene.addAnchor(portalAnchor!)
        
        // Create the portal frame
        let portalFrame = ModelEntity(
            mesh: .generateBox(width: 2.5, height: 3.0, depth: 0.2),
            materials: [PortalMaterial.createPortalFrameMaterial()]
        )
        
        // Create portal door (invisible material with occlusion)
        let portalDoor = ModelEntity(
            mesh: .generatePlane(width: 2.3, height: 2.8),
            materials: [PortalMaterial.createPortalDoorMaterial()]
        )
        portalDoor.position = [0, 0, -0.05]
        
        // Add portal frame and door to the anchor
        portalFrame.addChild(portalDoor)
        portalAnchor!.addChild(portalFrame)
        
        // Create Mars scene inside the portal
        createMarsEnvironment()
    }
    
    private func createMarsEnvironment() {
        guard let portalAnchor = portalAnchor else { return }
        
        // Create a Mars terrain entity
        do {
            // Try to load Mars terrain model
            let marsTerrainEntity = try ModelEntity.load(named: "mars_terrain")
            
            // Scale and position the Mars terrain
            marsTerrainEntity.scale = [0.1, 0.1, 0.1]
            marsTerrainEntity.position = [0, -1.5, -3.0]
            
            marsScene = Entity()
            marsScene?.addChild(marsTerrainEntity)
            portalAnchor.addChild(marsScene!)
            
            // Add atmospheric effects
            addMarsAtmosphere()
            
            // Add interactive elements
            addScientificStations()
            addAstronauts()
            
        } catch {
            print("Failed to load Mars terrain model: \(error.localizedDescription)")
            
            // Fallback: Create a simple Mars terrain using primitives
            let marsTerrainFallback = ModelEntity(
                mesh: .generateBox(width: 10, height: 0.5, depth: 10),
                materials: [PortalMaterial.createMarsTerrainMaterial()]
            )
            marsTerrainFallback.position = [0, -1.5, -3.0]
            
            marsScene = Entity()
            marsScene?.addChild(marsTerrainFallback)
            portalAnchor.addChild(marsScene!)
            
            // Add atmospheric effects
            addMarsAtmosphere()
            
            // Add interactive elements
            addScientificStations()
            addAstronauts()
        }
    }
    
    private func addMarsAtmosphere() {
        guard let marsScene = marsScene else { return }
        
        // Create a particle system for dust
        let dustParticles = createDustParticleSystem()
        marsScene.addChild(dustParticles)
        
        // Add reddish directional light for Mars sunlight
        let directionalLight = DirectionalLight()
        directionalLight.light.color = .init(red: 1.0, green: 0.7, blue: 0.6)
        directionalLight.light.intensity = 1500
        directionalLight.shadow = DirectionalLightComponent.Shadow(maximumDistance: 20, depthBias: 0.1)
        directionalLight.orientation = simd_quatf(angle: -.pi / 3, axis: [1, 0, 0])
        marsScene.addChild(directionalLight)
    }
    
    private func createDustParticleSystem() -> Entity {
        let particleSystem = Entity()
        
        // In a real app, we would create a particle system here
        // Since we can't include actual assets, we're simulating this with a visual placeholder
        let dustIndicator = ModelEntity(
            mesh: .generateSphere(radius: 0.05),
            materials: [SimpleMaterial(color: .red.withAlphaComponent(0.3), isMetallic: false)]
        )
        dustIndicator.position = [0, 1, -3]
        
        particleSystem.addChild(dustIndicator)
        return particleSystem
    }
    
    private func addScientificStations() {
        guard let marsScene = marsScene else { return }
        
        // Create and add scientific stations to the Mars scene
        let stationPositions: [SIMD3<Float>] = [
            [-1.0, -1.2, -4.0],
            [1.2, -1.2, -3.5],
            [0.0, -1.2, -5.0]
        ]
        
        let stationTypes = ["Research Lab", "Communication Center", "Power Station"]
        
        for i in 0..<min(stationPositions.count, stationTypes.count) {
            let station = ScientificStation(name: stationTypes[i], description: "A \(stationTypes[i].lowercased()) for Mars operations")
            station.position = stationPositions[i]
            station.scale = [0.3, 0.3, 0.3]
            
            stations.append(station)
            marsScene.addChild(station)
        }
    }
    
    private func addAstronauts() {
        guard let marsScene = marsScene else { return }
        
        // Create and add astronauts to the Mars scene
        let astronautPositions: [SIMD3<Float>] = [
            [-0.7, -1.2, -3.0],
            [0.7, -1.2, -4.0]
        ]
        
        let astronautNames = ["Commander Lewis", "Specialist Chen"]
        
        for i in 0..<min(astronautPositions.count, astronautNames.count) {
            let astronaut = Astronaut(name: astronautNames[i], description: "Mars mission astronaut performing exploration tasks")
            astronaut.position = astronautPositions[i]
            astronaut.scale = [0.15, 0.15, 0.15]
            
            astronauts.append(astronaut)
            marsScene.addChild(astronaut)
            
            // Set up animation for astronauts
            animateAstronaut(astronaut)
        }
    }
    
    private func animateAstronaut(_ astronaut: Astronaut) {
        // Create a simple movement animation
        let initialPosition = astronaut.position
        let targetPosition = initialPosition + SIMD3<Float>(0.0, 0.0, -0.5)
        
        // Create back and forth animation
        let moveForward = Transform(scale: .one, rotation: astronaut.orientation, translation: targetPosition)
        let moveBack = Transform(scale: .one, rotation: astronaut.orientation, translation: initialPosition)
        
        astronaut.move(to: moveForward, relativeTo: marsScene, duration: 5.0, timingFunction: .easeInOut)
            .completionHandler = { [weak self, weak astronaut] in
                guard let astronaut = astronaut else { return }
                
                astronaut.move(to: moveBack, relativeTo: self?.marsScene, duration: 5.0, timingFunction: .easeInOut)
                    .completionHandler = { [weak self, weak astronaut] in
                        // Repeat the animation
                        if let astronaut = astronaut {
                            self?.animateAstronaut(astronaut)
                        }
                    }
            }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEntityTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleEntityTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        guard let entity = self.entity(at: tapLocation) else { return }
        
        // If we have a parent entity that is interactive, select that instead
        var currentEntity: Entity? = entity
        while currentEntity != nil {
            if let interactiveEntity = currentEntity as? InteractiveEntity {
                selectionHandler?(interactiveEntity)
                return
            }
            currentEntity = currentEntity?.parent
        }
    }
    
    private func updateScene(_ event: SceneEvents.Update) {
        // Update astronaut animations or other time-based effects
        for astronaut in astronauts {
            if currentConfiguration.animateAstronauts {
                // Astronauts are already animated via the animateAstronaut function
            }
        }
        
        // Update scientific station effects
        for station in stations {
            if currentConfiguration.showStationEffects {
                // Update station effects (in a real app, we might add particle effects,
                // lights, or other visual indicators here)
            }
        }
    }
    
    func updateConfiguration(_ config: MarsConfiguration) {
        // Update scene based on new configuration
        currentConfiguration = config
        
        // Toggle visibility of elements based on configuration
        for station in stations {
            station.isEnabled = config.showScientificStations
        }
        
        for astronaut in astronauts {
            astronaut.isEnabled = config.showAstronauts
        }
        
        // Update lighting
        if let directionalLight = marsScene?.findEntity(named: "directionalLight") as? DirectionalLight {
            directionalLight.light.intensity = config.lightIntensity
        }
    }
}
