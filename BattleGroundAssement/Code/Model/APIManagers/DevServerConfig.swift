//
//  DevServerConfig.swift
//  BattleGroundAssement
//
//  Toggle local dev server here. This is read at runtime and overrides any UI/defaults.
//  Update `forceUseLocalServer` to true to point the app to your local API server without logging in.
//

import Foundation

enum DevServerConfig {
    /// If true, forces networking to use `localBaseURL` regardless of user settings.
    static var forceUseLocalServer: Bool = false

    /// Local development server base URL. Update as needed (e.g., your machine IP on device).
    static var localBaseURL: String = "http://127.0.0.1:8000"
}

