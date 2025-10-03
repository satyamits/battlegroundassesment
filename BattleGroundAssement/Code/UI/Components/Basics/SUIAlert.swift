//
//  SUIAlert.swift
//  BattleGroundAssement
//
//  Created by Satyam on 25/06/25.
//

import SwiftUI

struct SUIAlertView: View {
    @Binding var alertType: SUIAlertType
    var actions: [SUIAlertAction]
    var body: some View {
        VStack(spacing: 30) {
            Text(alertType.title)
                .font(.primary(.b24))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            // Image
            alertImage
                .frame(width: 88, height: 88)
            
            Text(alertType.message)
                .foregroundColor(Color.black)
                .font(.primary(.b18))
                .multilineTextAlignment(.center)
                .lineLimit(4)
            
            HStack(spacing: 24) {
                if !actions.isEmpty {
                    ForEach(actions) { action in
                        self.actionButton(type: action)
                    }
                } else {
                    Button {
                        self.alertType = .none
                    } label: {
                        HStack {
                            Spacer()
                            Text("Okay")
                                .font(.primary(.b14))
                                .foregroundColor(Color.white)
                            Spacer()
                            
                        }
                        .frame(height: 54)
                        .reusableButtonGradientBackground(isEnabled: true)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    var alertImage: some View {
        switch alertType {
        case .error:
            Image(uiImage: Images.errorWarningIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .success:
            Image(uiImage: Images.successIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .custom(_, _):
            Image(uiImage: Images.warningIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func actionButton(type: SUIAlertAction) -> some View {
        switch type {
        case .primary(let title, let action):
            Button {
                self.alertType = .none
                action()
            } label: {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.primary(.b14))
                        .foregroundColor(Color.white)
                    Spacer()
                    
                }
                .frame(height: 54)
                .reusableButtonGradientBackground(isEnabled: true)
                .cornerRadius(8)
            }
        case .secondary(let title, let action):
            Button {
                self.alertType = .none
                action()
            } label: {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.primary(.b14))
                        .foregroundColor(Color.black)
                    Spacer()
                    
                }
                .frame(height: 54)
                .background(.white)
                .cornerRadius(8)
            }
        case .tertiary(title: let title, action: let action):
            Button {
                self.alertType = .none
                action()
            } label: {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.primary(.b14))
                        .foregroundColor(Color.black)
                    Spacer()
                    
                }
                .frame(height: 54)
                .background(.white)
                .cornerRadius(8)
            }
        }
        
    }
}

struct SUIAlertModifier: ViewModifier {
    @Binding var alertType: SUIAlertType
    var actions: [SUIAlertAction]
    func body(content: Content) -> some View {
        ZStack {
            content
            
            switch alertType {
            case .none:
                EmptyView()
            default:
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                SUIAlertView(alertType: $alertType, actions: actions)
            }
        }
    }
}

extension View {
    func bindAlert(withAlertType alertType: Binding<SUIAlertType>,
                   andActions actions: [SUIAlertAction] = []) -> some View {
        self.modifier(SUIAlertModifier(alertType: alertType, actions: actions))
    }
}
