//
//  View+Extensions.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 17/06/25.
//

import Foundation

import SwiftUI

extension LinearGradient {
    
    static let clearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.clear, Color.clear]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static var sessionPrimary: LinearGradient {
        LinearGradient(colors: [Color.sessionButtonGradientPrimary,
                                Color.sessionButtonGradientSecondary],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    public  static let pausedProgressGradient = LinearGradient(
        gradient: Gradient(colors: [Color.lime, Color.textOrange
                                   ]),
        startPoint: .top,
        endPoint: .bottom)
    
    public  static let progressGradient = LinearGradient(
        gradient: Gradient(colors: [Color.lime, Color.successGreen
                                   ]),
        startPoint: .top,
        endPoint: .bottom)
    
    public static let editGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.summaryGradientPrimary,
            Color.summaryGradientSecondary,
            Color.summaryGradientTertiary,
            Color.summaryGradientTertiary
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let liveSessionGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.jewel,
            Color.liveSessionGrad2,
            Color.deepTeal
        ]),
        startPoint: .top,
        endPoint: .bottom)
    public static let pausedSessionGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.pausedSessionGrad1,
            Color.pausedSessionGrad2
        ]),
        startPoint: .top,
        endPoint: .bottom)
    
    public static let sessionButtonGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.sessionButtonGradientPrimary,
            Color.sessionButtonGradientSecondary
        ]),
        startPoint: .leading,
        endPoint: .trailing)
    
    public static let sessionSummaryGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.summaryGradientPrimary,
            Color.summaryGradientSecondary,
            Color.summaryGradientTertiary
        ]),
        startPoint: .leading,
        endPoint: .trailing)
    
    public static let reusableButtonGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.gradeintButtonColorPrimary,
            Color.gradeintButtonColorSecondary,
            Color.deepSea
        ]), startPoint: .leading, endPoint: .trailing)
    
    public static let disabledReusableButtonGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.overlayLight.opacity(0.15),
        ]), startPoint: .leading, endPoint: .trailing)
    
    public static let aeroBorderGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.aeroBorderPrimary,
            Color.aeroBorderSecondary
        ]), startPoint: .top, endPoint: .bottom)
}


struct EditGradientModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(LinearGradient(colors: [Color.midnightTransparent.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
            )
    }
}

struct SessionGradientModifier: ViewModifier {
    var isLiveSession: Bool
    func body(content: Content) -> some View {
        content
            .background(
                isLiveSession
                ? LinearGradient.liveSessionGradient
                : LinearGradient.pausedSessionGradient
            )
    }
}

struct SessionButtonGradientModifier: ViewModifier {
    var isLiveSession: Bool
    func body(content: Content) -> some View {
        content
            .background(
                isLiveSession
                ? LinearGradient.sessionButtonGradient
                : LinearGradient(colors: [
                    Color.sessionButtonGradientSecondary,
                    Color.sessionButtonGradientPrimary
                ], startPoint: .leading, endPoint: .trailing)
            )
            .foregroundColor(.white)
    }
}

struct SessionSummaryViewGradientBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(LinearGradient.sessionSummaryGradient)
    }
}

struct AeroBorderModifier: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isSelected ? LinearGradient.aeroBorderGradient : LinearGradient.clearGradient,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
    }
}

struct ReusableButtonGradientModifier: ViewModifier {
    var isEnabled: Bool
    func body(content: Content) -> some View {
        content
            .font(.primary(.s18))
            .foregroundColor(isEnabled ? Color.themeWhite : Color.themeWhite.opacity(0.20))
            .background(isEnabled ? LinearGradient.reusableButtonGradient : LinearGradient.disabledReusableButtonGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func editGradientBackground() -> some View {
        self.modifier(EditGradientModifier())
    }
    
    func trackSessionGradientBackground(_ isLiveSession: Bool) -> some View {
        self.modifier(SessionGradientModifier(isLiveSession: isLiveSession))
    }
    
    func sessionButtonGradientBackground(_ isLiveSession: Bool) -> some View {
        self.modifier(SessionButtonGradientModifier(isLiveSession: isLiveSession))
    }
    
    func sessionSummaryViewGradientBackground() -> some View {
        self.modifier(SessionSummaryViewGradientBackgroundModifier())
    }
    
    func reusableButtonGradientBackground(isEnabled: Bool) -> some View {
        self.modifier(ReusableButtonGradientModifier(isEnabled: isEnabled))
    }
    
    func aeroBorder(if isSelected: Bool) -> some View {
        self.modifier(AeroBorderModifier(isSelected: isSelected))
    }
}

struct GradientProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.shuttleGray)
                    .frame(height: 4)
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.lime, Color.successGreen]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: geo.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: 4)
                    .animation(.easeInOut(duration: 0.3), value: configuration.fractionCompleted)
            }
        }
        .frame(height: 4)
    }
}


extension View {
    static var tag: String {
        String(describing: self)
    }
}


extension View {
    func innerShadow(color: Color = .themeWhite.opacity(0.4),
                     radius: CGFloat = 6,
                     cornerRadius: CGFloat = 24) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 2)
                    .shadow(color: color, radius: radius, x: 2, y: 2)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.themeWhite, Color.black, Color.themeWhite]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    )
            )
    }
}

struct GradientButton: View {
    let title: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.primary(.s18))
                .foregroundColor(Color.limeGreen)
                .frame(maxWidth: .infinity, minHeight: 54, maxHeight: 54)
                .background(gradient)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.dirtyGreen, lineWidth: 1)
                )
                .shadow(color: Color.darkestGreen, radius: 0, x: 0, y: 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
