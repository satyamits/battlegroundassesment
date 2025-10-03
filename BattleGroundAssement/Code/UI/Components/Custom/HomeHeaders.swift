//
//  ReusableHeaderView.swift
//  BattleGroundAssement
//
//  Created by Satyam on 25/06/25.
//

import Foundation
import SwiftUI

struct HomeHeaders: View {
    var showBackButton: Bool
    var title: String
    var onProfileTap: (() -> Void)? = nil
    var onInfoTap: (() -> Void)? = nil
    var backAction: (() -> Void)? = nil

    var body: some View {
        ZStack {
            
            HStack(spacing: 0) {
                
                Spacer()
                Text(title)
                    .font(.primary(.s18))
                    .foregroundStyle(Color.themeWhite)
                    .multilineTextAlignment(.center)
                Spacer()
                
            }
            HStack {
                if showBackButton {
                    Button {
                        if let backAction {
                            backAction()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.primary(.s18))
                            .foregroundStyle(Color.themeWhite)
                    }
                }
                Spacer()
                HStack(spacing: 16) {
                    if let onProfileTap {
                        Button {
                            onProfileTap()
                        } label: {
                            Image(systemName: "person.crop.circle")
                        }
                    }
                    if let onInfoTap {
                        Button {
                            onInfoTap()
                        } label: {
                            HStack(spacing: 4) {
                                Text("Logout")
                                    .font(.primary(.r16))
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                            .foregroundStyle(Color.themeWhite)
                        }
                    }
                }
            }
        }
    }
}
