//
//  SUILoader.swift
//  BattleGroundAssement
//
//  Created by Satyam on 25/06/25.
//

import SwiftUI
 
import MBProgressHUD

extension View {
    func bindLoader(isLoading: Bool) -> some View {
        ZStack {
            self
                .disabled(isLoading)
            if isLoading {
                HUDController(isLoading: isLoading)
                    .frame(width: 120, height: 120)
            }
        }
    }
    
    func bindTextLoader(isLoading: Bool, text: String) -> some View {
        ZStack {
            self.disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)
            if isLoading {
                HStack(spacing: 4) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.paper)
                        .frame(width: 30, height: 30)
                    Text("Deleting your account…")
                        .font(.primary(.r18))
                        .foregroundStyle(Color.paper)
                }
            }
        }
    }
}

struct HUDController: UIViewControllerRepresentable {
    let isLoading: Bool
    private let hudTag = 999999

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isLoading {
            // Avoid duplicating HUDs by checking tag
            if uiViewController.view.viewWithTag(hudTag) == nil {
                let hud = MBProgressHUD.showAdded(to: uiViewController.view, animated: true)
                hud.tag = hudTag
                hud.bezelView.style = .solidColor
                hud.bezelView.color = .clear
                hud.contentColor = .deepSea
//                hud.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                hud.backgroundView.color = .clear
                hud.backgroundView.style = .solidColor
            }
        } else {
            if let hud = uiViewController.view.viewWithTag(hudTag) as? MBProgressHUD {
                hud.hide(animated: true)
                hud.removeFromSuperview()
            }
        }
    }
}

final class SnackbarManager: ObservableObject {
    @Published var snackbar: Snackbar?

    func show(
        title: String,
        message: String,
        duration: TimeInterval = 5,
        icon: SnackbarIconType = .none,
        actionTitle: String? = nil,
        actionColor: Color = .red,
        action: (() -> Void)? = nil,
        backgroundColor: Color = .deepBlue,
        titleColor: Color = .orange,
        messageColor: Color = .themeWhite,
        position: Snackbar.Position = .top(offset: 0.4)
    ) {
        let snackbarIcon: Snackbar.Icon
        switch icon {
        case .none: snackbarIcon = .none
        case .info: snackbarIcon = .info
        case .warning: snackbarIcon = .warning
        case .error: snackbarIcon = .error
        case .success: snackbarIcon = .success
        case .system(let name, let color): snackbarIcon = .system(imageName: name, Color: color)
        case .custom(let name): snackbarIcon = .custom(imageName: name)
        }
        DispatchQueue.main.async {
            self.snackbar = Snackbar(
                title: title,
                message: message,
                properties: Snackbar.Properties(
                    position: position,
                    duration: .fixed(seconds: duration),
                    disableHapticVibration: true
                ),
                icon: snackbarIcon,
                action: {
                    if let title = actionTitle {
                        return .text(title, actionColor, action ?? {})
                    } else {
                        return .none
                    }
                }(),
                decorator: Snackbar.Decorator(
                    backgroundColor: backgroundColor,
                    titleTextColor: titleColor,
                    messageTextColor: messageColor
                )
            )
        }
    }
}

extension View {
    func bindSnackbar(from viewModel: SUIBaseViewModel) -> some View {
            self.snackbarView(
                snackbar: Binding(
                    get: { viewModel.snackbar },
                    set: { viewModel.snackbar = $0 }
                )
            )
        }
}

