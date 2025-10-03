//
//  Router.swift
//  BattleGroundAssement
//
//  Created by Satyam on 08/07/25.
//

import Foundation

public protocol BaseRouter: Router {
    
}

public protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: [String: String]? { get }
    var params: Any? { get }
    var encodableBody: Encodable? { get }
    var baseUrl: URL { get }
    var headers: [String: String] { get }
    var timeoutInterval: TimeInterval? { get }
    var keypathToMap: String? { get }
    var requiresAuth: Bool { get }
    func urlRequest() throws -> URLRequest
}


public extension Router {
    var method: HTTPMethod { .get }
    var path: String { "" }
    var queryParameters: [String: String]? { nil }
    var params: Any? { nil }
    var encodableBody: Encodable? { nil }
    var baseUrl: URL { AppSettings.shared.baseURL }
    var headers: [String: String] { [:] }
    var timeoutInterval: TimeInterval? { 30 }
    var keypathToMap: String? { nil }
    var requiresAuth: Bool { true }
    func urlRequest() throws -> URLRequest {
        let fullPath = baseUrl.appendingPathComponent(path)
        var components = URLComponents(url: fullPath, resolvingAgainstBaseURL: false)

        if let queryParameters = queryParameters {
            components?.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval ?? 30.0

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.addAppJsonContentType()
        if method == .post || method == .put || method == .patch || method == .delete {
            if let encodable = encodableBody {
                let encodedData = try JSONEncoder().encode(AnyEncodable(encodable))
                request.httpBody = encodedData
            } else if let body = params {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
            }
        }

        return request
    }
}
