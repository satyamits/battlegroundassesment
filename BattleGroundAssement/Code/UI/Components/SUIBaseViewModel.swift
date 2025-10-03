//
//  SUIBaseViewModel.swift
//  Hyxpro-fitness-app
//
//  Created by Satyam on 30/06/25.
//

import SwiftUI
import Combine
import UIKit

class SUIBaseViewModel: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var alert: SUIAlertType = .none
    @Published var showConfirmationAlert: SUIAlertType = .none
    @Published var takeConfirmationAlert: SUIAlertType = .none
    @Published var actionSheet: SUIActionSheetConfig?
    @Published var snackbar: Snackbar?
    @Published var showCountDownView: Bool = false
    @Published var shakeAnimation: Bool = false
    @Published var showTextedLoader: Bool = false
    @Published var loaderText: String = ""
    var shake = PassthroughSubject<Void, Never>()
    
    func needShake() {
        let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        self.shake.send()
    }
}

extension SUIBaseViewModel {
    func showLoader() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func showTextedLoader(withText text: String) {
        DispatchQueue.main.async {
            self.loaderText = text
            self.showTextedLoader = true
        }
    }
    
    func hideTextedLoader() {
        DispatchQueue.main.async {
            self.showTextedLoader = false
            self.loaderText = ""
        }
    }
    
        func openSupportMail(with message: String? = nil) {
            let supportEmail = "support@hyxpro.com"
            var body = "Please describe your issue here."
            
            if let message = message, !message.isEmpty {
                // Append error details
                body += "\n\n---\nError Details:\n\(message)"
            }
            
            // Encode subject & body
            let subject = "App Support Request"
            let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            guard let url = URL(string: "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)") else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }

}

extension SUIBaseViewModel {
    func showActionSheet(title: String,
                         message: String? = nil,
                         actions: [SUIAlertAction]) {
        DispatchQueue.main.async {
            self.actionSheet = SUIActionSheetConfig(title: title,
                                                    message: message,
                                                    actions: actions)
        }
    }

    func dismissActionSheet() {
        DispatchQueue.main.async {
            self.actionSheet = nil
        }
    }
}

extension SUIBaseViewModel {
    func showAlert(withAlert alertType: SUIAlertType) {
        DispatchQueue.main.async {
            self.alert = alertType
        }
    }
    
    func showConfirmationAlert(withAlert alertType: SUIAlertType) {
        DispatchQueue.main.async {
            self.showConfirmationAlert = alertType
        }
    }
    
    func takeConfirmationAlert(withAlert alertType: SUIAlertType) {
        DispatchQueue.main.async {
            self.takeConfirmationAlert = alertType
        }
    }
    
    
    func handleError(withError error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noInternet:
                self.showSnackbar(title: "No Internet Connection",
                                  message: L10n.Network.noInternet,
                                  icon: .system(imageName: "wifi.slash",
                                                Color: .hyxPink),
                                  position: .top(offset: 0.8))
            case .requestFailed(_):
                self.showSnackbar(title: "Connection Failed",
                                  message: L10n.Network.requestFailed,
                                  icon: .system(imageName: "flag.fill", Color: .hyxPink),
                                  action: .text("Support", .jewel, {
                    self.openSupportMail(with: error.localizedDescription)
                                  }))
            case .invalidResponse:
                self.showSnackbar(title: "Something's off!",
                                  message: L10n.Network.invalidResponse,
                                  icon: .system(imageName: "exclamationmark.icloud",
                                                Color: .hyxPink),
                                  action: .text("Support", .jewel, {
                    self.openSupportMail(with: error.localizedDescription)
                }))
            case .decodingError(let error):
                print(error)
                self.showSnackbar(title: "Data issue",
                                  message: L10n.Network.decodingError,
                                  icon: .system(imageName: "exclamationmark.arrow.trianglehead.2.clockwise.rotate.90",
                                                Color: .hyxPink),
                                  action: .text("Support", .jewel, {
                    self.openSupportMail(with: error.localizedDescription)
                }))
            case .serverError(let statusCode, let data):
                if statusCode == 401 {
                    DataModel.shared.logout()
                    self.showAlert(withAlert: .error(message: L10n.Error.sessionExpiredMessage))
                }
                if let extracted = extractMessage(from: data) {
                    self.showAlert(withAlert: .error(message: extracted))
                } else {
                    self.showSnackbar(title: "We're offline",
                                      message: L10n.Network.serverError,
                                      icon: .system(imageName: "wifi.slash",
                                                    Color: .hyxPink),
                                      action: .text("Support", .jewel, {
                        self.openSupportMail()
                    }),
                                      
                    )
                }
            case .invalidBody:
                self.showSnackbar(title: "Invalid Input",
                                  message: L10n.Network.invalidBody,
                                  icon: .system(imageName: "entry.lever.keypad.trianglebadge.exclamationmark.fill",
                                                Color: .hyxPink),
                                  action: .text("Support", .jewel, {
                    
                }))
            case .unknown:
                self.showSnackbar(title: "", message: "Unknown error occured")
            case .notLoggedIn:
                self.showAlert(withAlert: .error(message: L10n.Error.notLoggedIn))
            case .unauthorized:
                DataModel.shared.logout()
                self.showAlert(withAlert: .error(message: L10n.Error.unathorizedAccess))
            case .requestTimeout:
                self.showSnackbar(title: "Server Timeout",
                                  message: "The server took too long to respond. Please check your connection and try again later.",
                                  icon: .system(imageName: "icloud.slash.fill", Color: .hyxPink))
            }
        } else {
            self.showAlert(withAlert: .error(message: error.localizedDescription))
            print(error)
        }
    }


    
    private func extractMessage(from data: Data?) -> String? {
        guard let data = data else { return nil }
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let message = json["message"] as? String {
                return message
            } else if let error = json["error"] as? String {
                return error
            } else if let details = json["detail"] as? String {
                return details
            }
        }
        return nil
    }

}

extension SUIBaseViewModel {
    func showSnackbar(title: String,
                      message: String,
                      icon: Snackbar.Icon = .info,
                      duration: Snackbar.Duration = .fixed(seconds: 3),
                      actionTitle: String? = nil,
                      action: Snackbar.Action = .none,
                      backgroundColor: Color = .paper,
                      titleTextColor: Color = .blackPrimary,
                      messageTextColor: Color = .blackPrimary,
                      position: Snackbar.Position = .top(offset: 0.4),
                      disableHapticVibration: Bool = false) {
        
        self.snackbar = Snackbar(
            title: title,
            message: message,
            properties: .init(position: position,
                              duration: duration,
                              disableHapticVibration: disableHapticVibration),
            icon: icon,
            action: action,
            decorator: .init(
                backgroundColor: backgroundColor,
                titleTextColor: titleTextColor,
                messageTextColor: messageTextColor
            )
        )
    }
}


enum SUIAlertType: Equatable, Identifiable {
    case error(message: String)
    case success(message: String)
    case custom(title: String, message: String)
    case none
    
    var title: String {
        switch self {
        case .error:
            "Error"
        case .success:
            "Success"
        case .custom(let title, _):
            title
        case .none:
            ""
        }
    }
    
    var message: String {
        switch self {
        case .error(let message),
                .success(let message),
                .custom(_, let message):
            message
        case .none:
            ""
        }
    }
    
    var id: UUID {
        UUID()
    }
    
    static public func == (lhs: SUIAlertType, rhs: SUIAlertType) -> Bool {
        return (lhs.id == rhs.id)
    }
}

enum SUIAlertAction: Identifiable {
    case primary(title: String, action: () -> Void)
    case secondary(title: String, action: () -> Void)
    case tertiary(title: String, action: () -> Void)

    var id: UUID { UUID() }

    var title: String {
        switch self {
        case .primary(let title, _), .secondary(let title, _), .tertiary(let title, _):
            return title
        }
    }

    var style: Style {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        case .tertiary: return .tertiary
        }
    }

    var action: () -> Void {
        switch self {
        case .primary(_, let action), .secondary(_, let action), .tertiary(_, let action):
            return action
        }
    }

    enum Style {
        case primary
        case secondary
        case tertiary
    }
}


enum SnackbarIconType {
    case none
    case system(name: String, color: Color = .white)
    case custom(name: String)
    case info
    case warning
    case error
    case success
}

extension UIApplication {
    func endEditing(_ force: Bool = true) {
        self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .endEditing(force)
    }
}



