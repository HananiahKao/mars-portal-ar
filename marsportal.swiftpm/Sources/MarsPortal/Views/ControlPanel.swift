import SwiftUI

struct ControlPanel: View {
    @ObservedObject var config: MarsConfiguration
    
    @State private var selectedPreset: MarsPreset = .day
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mars Portal Controls")
                .font(.headline)
                .foregroundColor(.white)
            
            Divider()
                .background(Color.white.opacity(0.5))
            
            // Presets selector
            HStack {
                Text("Environment:")
                    .foregroundColor(.white)
                
                Picker("Environment", selection: $selectedPreset) {
                    ForEach(MarsPreset.allCases) { preset in
                        Text(preset.rawValue).tag(preset)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedPreset) { newValue in
                    config.applyPreset(newValue)
                }
            }
            
            // Toggle for showing scientific stations
            Toggle(isOn: $config.showScientificStations) {
                Text("Scientific Stations")
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            // Toggle for showing astronauts
            Toggle(isOn: $config.showAstronauts) {
                Text("Astronauts")
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            // Toggle for animating astronauts
            Toggle(isOn: $config.animateAstronauts) {
                Text("Animate Astronauts")
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .disabled(!config.showAstronauts)
            
            // Slider for dust intensity
            VStack(alignment: .leading) {
                Text("Dust Intensity")
                    .foregroundColor(.white)
                
                HStack {
                    Text("Low")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Slider(value: $config.dustIntensity, in: 0...1)
                        .accentColor(.orange)
                    
                    Text("High")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            // Slider for light intensity
            VStack(alignment: .leading) {
                Text("Light Intensity")
                    .foregroundColor(.white)
                
                HStack {
                    Text("Dark")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Slider(value: $config.lightIntensity, in: 300...2500, step: 100)
                        .accentColor(.yellow)
                    
                    Text("Bright")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: 350)
        .background(Color.black.opacity(0.6))
        .cornerRadius(15)
    }
}

struct ControlPanel_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            ControlPanel(config: MarsConfiguration())
        }
    }
}
