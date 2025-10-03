//
//  CustomGaugeView.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 19/06/25.
//

import SwiftUI

struct CustomGaugeView: View {
    var total: Int
    var current: Int
    var title: String

    private let strokeWidth: CGFloat = 6
    private let thumbSize: CGFloat = 14

    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return min(CGFloat(current) / CGFloat(total), 1.0)
    }

    var body: some View {
        ZStack {
            // Background arc
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(Color.gray.opacity(0.5), lineWidth: strokeWidth)
                .rotationEffect(.degrees(180))

            // Foreground progress arc
            Circle()
                .trim(from: 0.0, to: progress * 0.5)
                .stroke(Color.white, lineWidth: strokeWidth)
                .rotationEffect(.degrees(180))
                .animation(.easeInOut(duration: 0.5), value: current)

            // Center content
            VStack(spacing: 2) {
                Text("\(current)/\(total)")
                    .font(.primary(.s10))
                    .foregroundColor(Color.themeWhite)

                Text(title)
                    .font(.primary(.s10))
                    .foregroundColor(Color.themeWhite)
            }
        }
        .frame(width: 60, height: 60)
    }
}
