import SwiftUI

struct ObjectInfoView: View {
    let entity: InteractiveEntity
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with name and close button
            HStack {
                Text(entity.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.title3)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
            
            // Description
            Text(entity.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
            
            // Interact button
            Button(action: {
                entity.interact()
            }) {
                HStack {
                    Image(systemName: "hand.tap.fill")
                    Text("Interact")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.top, 8)
            
            // Additional information based on entity type
            Group {
                if entity is Astronaut {
                    VStack(alignment: .leading) {
                        Text("Astronaut Information")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Mission Role")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Text(entity.name.contains("Commander") ? "Mission Command" : "Specialist")
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Mission Day")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Text("\(Int.random(in: 45...120))")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                } else if entity is ScientificStation {
                    VStack(alignment: .leading) {
                        Text("Station Information")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Status")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Text("Operational")
                                    .foregroundColor(.green)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Power Level")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Text("\(Int.random(in: 75...98))%")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: 350)
        .background(Color.black.opacity(0.8))
        .cornerRadius(15)
    }
}
