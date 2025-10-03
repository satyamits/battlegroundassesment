//
//  GenericActionSheet.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 24/06/25.
//


import SwiftUI

struct GenericActionSheet<T: Identifiable & CustomStringConvertible>: View {
    let title: String
    let options: [T]
    let onSelect: (T) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text(title)
                    .font(.primary(.b14))
                    .foregroundStyle(Color.themeWhite)
                    .padding(8)
                Divider()
                    .background(Color.mutedTeal)
                ForEach(options) { item in
                    Button {
                        onSelect(item)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text(item.description)
                                .font(.primary(.r18))
                                .foregroundColor(Color.successGreen)
                            Spacer()
                        }
                        .background(Color.clear)
                    }
                    
                    Divider()
                        .background(Color.mutedTeal)
                }
            }
            .background(Color.whiteTransparent.opacity(0.4))
            .cornerRadius(16)
            Button {
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .font(.primary(.b18))
                        .foregroundColor(Color.themeWhite)
                    Spacer()
                }
                .frame(height: 56)
                .sessionButtonGradientBackground(true)
                .cornerRadius(10)
                .padding(.top, 8)
            }
        }
        .background(Color.clear)
        .padding(8)
    }
}

// MARK: - Action Sheet Button
struct CustomActionSheetButton: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
    var background: CustomBackgroundStyle = .color(.clear)
    var foregroundColor: Color = .primary
    var isDestructive: Bool = false
}


// MARK: - Custom Action Sheet View
struct CustomActionSheet: View {
    @Binding var isPresented: Bool
    let model: CustomActionSheetCellModel
    
    var body: some View {
        ZStack {
            if isPresented {
                // Dimmed background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { isPresented = false } }
                VStack(spacing: 12) {
                    Spacer()
                    VStack(spacing: 8) {
                        Text(model.title)
                            .font(.primary(.s14))
                            .padding(.top, 6)
                        
                        if let message = model.message {
                            Text(message)
                                .font(.primary(.r16))
                                .foregroundColor(.dividerGray)
                        }
                        
                        if model.message != nil || !model.title.isEmpty {
                            Divider()
                                .background(Color.mutedTeal)
                        }
                        ForEach(model.buttons) { button in
                            
                            Button(button.title) {
                                withAnimation { isPresented = false }
                                DispatchQueue.main.async {
                                    button.action()
                                }
                            }
                            .font(.primary(.r18))
                            .foregroundColor(button.isDestructive ? .themeWhite : button.foregroundColor)
                        }
                    }
                    .padding()
                    .background(
                        BlurView(style: .systemThickMaterialDark)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.themeWhite.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .shadow(radius: 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    if let cancelButton = model.cancelButton {
                        Button {
                            withAnimation { isPresented = false }
                            DispatchQueue.main.async {
                                cancelButton.action()
                            }
                        } label: {
                            Text(cancelButton.title)
                                .font(.primary(.s18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(backgroundView(for: cancelButton))
                                .foregroundColor(cancelButton.foregroundColor)
                                .cornerRadius(16)
                                .padding(.horizontal)
                        }
                    } else {
                        Button("Cancel") {
                            withAnimation { isPresented = false }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .padding(.top)
                    }
                }
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
    
    @ViewBuilder
    private func backgroundView(for button: CustomActionSheetButton) -> some View {
        switch button.background {
        case .color(let color):
            color
        case .gradient(let gradient):
            gradient
        }
    }
}
extension View {
    func customActionSheet(
        isPresented: Binding<Bool>,
        model: CustomActionSheetCellModel
    ) -> some View {
        self.overlay(
            CustomActionSheet(isPresented: isPresented, model: model)
        )
    }
}

struct CustomActionSheetCellModel {
    let title: String
    let message: String?
    var backgroundColor: Color = Color.whiteTransparent.opacity(0.5)
    var cornerRadius: CGFloat = 14
    var buttons: [CustomActionSheetButton]
    var cancelButton: CustomActionSheetButton? = nil
}
enum CustomBackgroundStyle {
    case color(Color)
    case gradient(LinearGradient)
}
