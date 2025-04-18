import SwiftUI
import ARKit
import RealityKit

struct ContentView: View {
    @State private var isControlPanelVisible = true
    @State private var selectedEntity: InteractiveEntity?
    @State private var arViewCreated = false
    
    let marsConfig = MarsConfiguration()
    
    var body: some View {
        ZStack {
            // AR View Container
            ARViewContainer(selectedEntity: $selectedEntity, marsConfig: marsConfig)
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
                .onAppear {
                    arViewCreated = true
                }
            
            // Overlay UI
            VStack {
                if isControlPanelVisible {
                    ControlPanel(config: marsConfig)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(15)
                        .transition(.move(edge: .top))
                }
                
                Spacer()
                
                // Toggle button for control panel
                Button(action: {
                    withAnimation {
                        isControlPanelVisible.toggle()
                    }
                }) {
                    Image(systemName: isControlPanelVisible ? "chevron.up" : "chevron.down")
                        .font(.title)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.bottom, 20)
            }
            
            // Entity info overlay when an entity is selected
            if let entity = selectedEntity {
                VStack {
                    Spacer()
                    ObjectInfoView(entity: entity, onDismiss: {
                        selectedEntity = nil
                    })
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                    .padding(.bottom, 80)
                    .transition(.move(edge: .bottom))
                }
            }
            
            // Initial instructions overlay
            if !arViewCreated {
                VStack {
                    Text("Move your iPad to detect surfaces")
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
