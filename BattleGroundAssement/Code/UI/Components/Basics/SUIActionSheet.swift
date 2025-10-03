//
//  SUIActionSheet.swift
//  BattleGroundAssement
//
//  Created by Satyam on 22/07/25.
//

import Foundation
import SwiftUI

struct SUIActionSheet: View {
    let title: String
    let message: String?
    var actions: [SUIAlertAction]
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Text(title)
                            .font(.primary(.m18).smallCaps())
                            .foregroundColor(Color.themeWhite)
                            .padding(.top, 12)
                            .padding(.bottom, 4)
                        
                        if let message = message {
                            Text(message)
                                .font(.primary(.r14))
                                .foregroundColor(Color.paper)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 16)
                                .padding(.horizontal, 24)
                        }
                        
                        ForEach(actions) { action in
                            Button {
                                isPresented = false
                                action.action()
                            } label: {
                                Text(action.title)
                                    .font(.primary(.r18))
                                    .foregroundColor(foregroundColor(for: action.style))
                                    .frame(maxWidth: .infinity, minHeight: 48)
                            }
                            .background(
                                Divider().background(Color.themeWhite.opacity(0.1)),
                                alignment: .top
                            )
                        }
                    }
                    .background(
                        BlurView(style: .systemThickMaterialDark)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.themeWhite.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 12)
                    .shadow(radius: 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(), value: isPresented)
                }
            }
        }
    }

    func foregroundColor(for style: SUIAlertAction.Style) -> Color {
        switch style {
        case .primary:
            return Color.successGreen
        case .secondary:
            return Color.aeroBorderPrimary
        case .tertiary:
            return Color.red
        }
    }
}


struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

struct SUIActionSheetConfig: Identifiable {
    let id = UUID()
    let title: String
    let message: String?
    let actions: [SUIAlertAction]
}

struct SUIActionSheetModifier: ViewModifier {
    @Binding var config: SUIActionSheetConfig?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if let config = config {
                SUIActionSheet(
                    title: config.title,
                    message: config.message,
                    actions: config.actions,
                    isPresented: Binding(
                        get: { config != nil },
                        set: { newValue in
                            if !newValue {
                                self.config = nil
                            }
                        }
                    )
                )
            }
        }
    }
}

extension View {
    func bindActionSheet(config: Binding<SUIActionSheetConfig?>) -> some View {
        self.modifier(SUIActionSheetModifier(config: config))
    }
}
