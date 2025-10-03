//
//  DeviceSelectionPopupView.swift
//  BattleGroundAssement
//

import SwiftUI

struct DeviceSelectionPopupView: View {
    @Binding var isPresented: Bool
    let onDeviceSelected: (WorkoutDevice) -> Void
    
    enum WorkoutDevice {
        case appleWatch
        case iPhone
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text("Where do you want to perform this workout?")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 32)
            
            // Device Options
            VStack(spacing: 16) {
                // Apple Watch Option
                Button(action: {
                    onDeviceSelected(.appleWatch)
                    isPresented = false
                }) {
                    HStack {
                        Image(systemName: "applewatch")
                            .foregroundColor(.green)
                            .font(.system(size: 20))
                        Text("Send to Watch")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                
                // iPhone Option
                Button(action: {
                    onDeviceSelected(.iPhone)
                    isPresented = false
                }) {
                    HStack {
                        Image(systemName: "iphone")
                            .foregroundColor(.green)
                            .font(.system(size: 20))
                        Text("Start on iPhone")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Cancel Button
            Button(action: {
                isPresented = false
            }) {
                Text("Cancel")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color.deepBlue)
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    DeviceSelectionPopupView(isPresented: .constant(true)) { device in
        print("Selected device: \(device)")
    }
} 
