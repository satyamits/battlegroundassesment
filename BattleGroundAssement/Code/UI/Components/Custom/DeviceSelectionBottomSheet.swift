//
//  DeviceSelectionBottomSheet.swift
//  BattleGroundAssement
//

import SwiftUI

struct DeviceSelectionBottomSheet: View {
    @Binding var isPresented: Bool
    let onDeviceSelected: (DeviceSelectionPopupView.WorkoutDevice) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 16)
            
            // Title
            Text("Where do you want to perform this workout?")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            
            // Device Options
            VStack(spacing: 12) {
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
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
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
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity)
        .background(Color.deepBlue)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    DeviceSelectionBottomSheet(isPresented: .constant(true)) { device in
        print("Selected device: \(device)")
    }
} 
