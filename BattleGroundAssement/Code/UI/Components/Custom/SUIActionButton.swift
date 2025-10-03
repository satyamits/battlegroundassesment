//
//  SUIActionButton.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 18/06/25.
//

import Foundation
import SwiftUI

struct SUIActionButton: View {
    
    var title: String
    var isEnabled: Bool = false
    var action: () -> Void
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        Button {
            action()
            self.hapticFeedback.impactOccurred()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    
                Spacer()
            }
            .padding()
            .reusableButtonGradientBackground(isEnabled: isEnabled)
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
        .onAppear {
            self.hapticFeedback.prepare()
        }
    }
}
