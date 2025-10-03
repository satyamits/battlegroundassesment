//
//  AppSettings.swift
//  BattleGroundAssement
//
//  Global runtime-configurable settings (dev server toggle, etc.).
//

import Foundation
import Combine

final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    private enum Keys {
        static let useLocalServer = "app.useLocalServer"
        static let localServerURL = "app.localServerURL"
    }

    @Published var useLocalServer: Bool {
        didSet { UserDefaults.standard.set(useLocalServer, forKey: Keys.useLocalServer) }
    }

    @Published var localServerURL: String {
        didSet { UserDefaults.standard.set(localServerURL, forKey: Keys.localServerURL) }
    }

    var currentBaseURLString: String {
        // Code-level override takes precedence (edit DevServerConfig.swift)
        if DevServerConfig.forceUseLocalServer {
            return DevServerConfig.localBaseURL
        }
        return useLocalServer ? localServerURL : APIConfig.APIUrl.dev
    }

    var baseURL: URL {
        URL(string: currentBaseURLString) ?? URL(string: APIConfig.APIUrl.dev)!
    }

    private init() {
        let defaults = UserDefaults.standard
        // Default off; default URL points to local FastAPI/Django dev server
        self.useLocalServer = defaults.bool(forKey: Keys.useLocalServer)
        let savedURL = defaults.string(forKey: Keys.localServerURL)
        self.localServerURL = savedURL ?? "http://127.0.0.1:8000"
    }
}
