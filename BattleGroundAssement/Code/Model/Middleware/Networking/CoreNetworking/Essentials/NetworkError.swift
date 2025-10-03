//
//  NetworkError.swift
//  Hyxpro-fitness-app
//
//  Created by Satyam on 08/07/25.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case noInternet
    case notLoggedIn
    case unauthorized
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int, data: Data?)
    case invalidBody
    case requestTimeout
    case unknown

    var description: String {
        switch self {
        case .noInternet: return "No Internet Connection"
        case .requestFailed(let error): return "Request Failed: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid Response"
        case .decodingError(let error): return "Decoding Error: \(error.localizedDescription)"
        case .serverError(let code, _): return "Server Error: HTTP \(code)"
        case .unknown: return "Unknown Error"
        case .invalidBody: return "Invalid body format. Expected JSON object or array."
        case .notLoggedIn: return "User not logged in"
        case .unauthorized: return "Unauthorized access. Please Login again."
        case .requestTimeout: return "Request timed out."
        }
    }
}
